/*
Find job postings from the first quarter that have a salary greater than $70K
-Combine job posting tables from the first quarter of 2023 (Jan-Mar)
-Get job postings with an average yearly salary > $70,000
*/

--Could remove the table alias when specifying the columns
--Shouldn't cause an issue
SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date :: DATE,
    quarter1_job_postings.salary_year_avg
FROM
    (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs
    
    UNION ALL

    SELECT *
    FROM march_jobs
    
    ) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Business Analyst'

ORDER BY
    quarter1_job_postings.salary_year_avg DESC
