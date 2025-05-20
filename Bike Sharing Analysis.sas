libname bshare '/home/u62009805/Bike Sharing';

/*Step 1 : Import daily data */
proc import datafile='/home/u62009805/Bike Sharing/day.csv'
    out=bshare.day
    dbms=csv
    replace;
    getnames=yes;
run;

/* Import hourly data */
proc import datafile='/home/u62009805/Bike Sharing/hour.csv'
    out=bshare.hour
    dbms=csv
    replace;
    getnames=yes;
run;


proc format;
  value season
    1 = 'Spring'
    2 = 'Summer'
    3 = 'Fall'
    4 = 'Winter';
  value weather
    1 = 'Clear'
    2 = 'Misty/Cloudy'
    3 = 'Rain/Snow';
run;

/* Daily data */
data bshare.daily_enhanced;
  set bshare.day;
  total_users = casual + registered;
  weekend_flag = (weekday in (0,6));
  season_name = put(season, season.);
  weather_type = put(weathersit, weather.);
  
  format season season. weathersit weather.;
  
  label total_users = 'Total Bike Users'
        weekend_flag = 'Weekend (1) vs Weekday (0)';
run;

/* Hourly data */
data bshare.hour;
  set bshare.hour;
  length time_cat $12;
  select;
    when(hr in (7:9)) time_cat = 'Morning Rush';
    when(hr in (11:13)) time_cat = 'Midday';
    when(hr in (16:18)) time_cat = 'Evening Rush';
    otherwise time_cat = 'Off-Peak';
  end;

  format season season. weathersit weather.;
run;

/*Step 2 : Key Statistical Measures Analysis */
/* Univariate analysis for registered and casual users */
proc univariate data=bshare.daily_enhanced;
  var casual registered;
  histogram / normal;
  inset mean std skewness kurtosis / position=ne;
  title 'Distribution of User Types';
run;
/* Looking at measures of center and spread for both user types */

/* Extreme value identification */
proc means data=bshare.daily_enhanced n nmiss min max p99;
  var casual registered;
  class season weekday;
  title 'Extreme Values by Season and Weekday';
run;
/* Identifying unusually high/low usage days */

/* Step 3 : Year-over-Year Comparison */
/* Registered user growth analysis */
proc sgplot data=bshare.daily_enhanced;
  vline mnth / response=registered group=yr stat=mean markers;
  xaxis label='Month' values=(1 to 12);
  yaxis label='Average Registered Users';
  title 'Monthly Registered Users: 2011 vs 2012';
run;
/* Visual comparison of yearly patterns */

/* Statistical test for yearly difference */
proc ttest data=bshare.daily_enhanced;
  class yr;
  var registered;
  title 'Test for Difference in Registered Users Between Years';
run;
/* Testing if 2012 shows significant growth */


/*Step 4 : Confidence Interval Analysis*/
/* First, ensure formats are properly defined */
proc format;
  value seasonfmt
    1 = 'Spring'
    2 = 'Summer'
    3 = 'Fall'
    4 = 'Winter';
run;

/* Create a results dataset instead of _null_ */
%macro test_claim(season, value, direction);
  data claim_test_&season;
    set bshare.daily_enhanced(where=(yr=1 & season=&season)) end=eof;
    retain n sum sum_sq;
    if _n_=1 then do;
      n=0; sum=0; sum_sq=0;
    end;
    n+1;
    sum+total_users;
    sum_sq+total_users**2;
    if eof then do;
      mean=sum/n;
      std=sqrt((sum_sq-sum**2/n)/(n-1));
      t_value=(mean-&value)/(std/sqrt(n));
      df=n-1;
      
      /* Corrected p-value calculation */
      if upcase("&direction")="GE" then do;
        /* Testing if mean ≥ claim value */
        p_value=1-probt(t_value,df); /* Right-tailed */
        conclusion=ifc(mean>=&value,"Supports claim","Rejects claim");
      end;
      else if upcase("&direction")="LE" then do;
        /* Testing if mean ≤ claim value */
        p_value=probt(t_value,df); /* Left-tailed */
        conclusion=ifc(mean<=&value,"Supports claim","Rejects claim");
      end;
      
      /* Add identifying information */
      season_number=&season;
      season_name=put(&season, seasonfmt.);
      claim="&direction &value";
      
      /* Keep only the summary stats */
      keep season_number season_name claim mean std n t_value df p_value conclusion;
      output;
    end;
  run;
%mend;

/* Execute tests for all claims */
%test_claim(1, 4000, ge); /* Spring ≥4000 */
%test_claim(2, 6500, ge); /* Summer ≥6500 */
%test_claim(3, 6500, le); /* Fall ≤6500 */
%test_claim(4, 5000, le); /* Winter ≤5000 */

/* Combine all results */
data all_claims;
  set claim_test_:;
run;

/* Display formatted results */
proc print data=all_claims noobs label;
  format p_value pvalue6.4 mean std comma8.2;
  label season_name = "Season"
        claim = "Marketing Claim"
        mean = "Actual Mean"
        std = "Standard Deviation"
        n = "Days Observed"
        t_value = "t Statistic"
        df = "Degrees of Freedom"
        p_value = "p-value"
        conclusion = "Conclusion";
  title "Marketing Claims Validation Results";
run;


/* CI 2: Seasonal comparison (Fall vs Summer) */
proc means data=bshare.daily_enhanced n mean stddev clm;
  where yr=1;
  class season;
  var total_users;
  title 'Average Daily Users by Season with 95% CIs (2012)';
run;
/* Comparing seasonal averages with confidence intervals */

/* CI 3: Weekend vs Weekday difference */
proc ttest data=bshare.daily_enhanced;
  class weekend_flag;
  var total_users;
  title 'Difference in Usage: Weekends vs Weekdays';
run;
/* Two-sample confidence interval for mean difference */


/*Step 5 : Hypothesis Testing Section */
/* Test 1: Marketing claims validation */
proc means data=bshare.daily_enhanced mean stddev;
  where yr=1;
  class season;
  var total_users;
  title 'Descriptive Stats for Marketing Claims Validation';
run;

/* One-sample t-tests for each claim */
%macro test_claim(season, value, direction);
  data result_&season;
    set bshare.daily_enhanced(where=(yr=1 & season=&season)) end=eof;
    retain n sum sum_sq;
    if _n_ = 1 then do;
      n = 0; sum = 0; sum_sq = 0;
    end;
    n + 1;
    sum + total_users;
    sum_sq + total_users**2;
    if eof then do;
      mean = sum/n;
      std = sqrt((sum_sq - sum**2/n) / (n-1));
      t = (mean - &value) / (std / sqrt(n));
      df = n - 1;
      if "&direction" = "ge" then p = probt(t, df);
      else if "&direction" = "le" then p = 1 - probt(t, df);
      season = &season;
      claim = "&direction &value";
      output;
    end;
    keep season mean t df p claim;
  run;

  proc print data=result_&season label;
    title "T-Test Results for Season &season";
  run;
%mend;

%test_claim(1, 4000, ge);
%test_claim(2, 6500, ge);
%test_claim(3, 6500, le);
%test_claim(4, 5000, le);



/* Test 2: Seasonal comparisons (ANOVA) */
proc glm data=bshare.daily_enhanced;
  where yr=1;
  class season;
  model total_users = season;
  means season / tukey;
  title 'ANOVA for Seasonal Differences (2012)';
run;
/* Testing if seasons have different average usage */

/* Test 3: Weather impact analysis */
proc glm data=bshare.daily_enhanced;
  class weathersit;
  model casual = weathersit;
  means weathersit / tukey;
  title 'ANOVA for Casual Users by Weather Type';
run;
/* Testing if weather affects casual users differently */

proc glm data=bshare.daily_enhanced;
  class weathersit;
  model registered = weathersit;
  means weathersit / tukey;
  title 'ANOVA for Registered Users by Weather Type';
run;
/* Testing if weather affects registered users */

/* Step 6 : Advanced Hourly Analysis */
/* Peak hour patterns */
proc sgpanel data=bshare.hour;
  where workingday=1;
  panelby time_cat;
  histogram cnt / scale=count;
  title 'Ride Distribution by Time Category (Workdays)';
run;
/* Visualizing usage patterns throughout day */

/* Weather impact by hour */
proc means data=bshare.hour mean;
  class time_cat weathersit;
  var casual registered;
  title 'Average Hourly Usage by Time and Weather';
run;
/* Examining how weather affects different times */

/* Registered vs casual patterns */
proc sgplot data=bshare.hour;
  series x=hr y=registered / legendlabel='Registered';
  series x=hr y=casual / y2axis legendlabel='Casual';
  xaxis label='Hour of Day';
  yaxis label='Registered Users';
  y2axis label='Casual Users';
  title 'Hourly Usage Patterns by User Type';
run;
/* Comparing daily patterns between user types */

