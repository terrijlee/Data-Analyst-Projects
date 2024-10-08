/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
-Identify skills in high demand and associated with high average salaries for Data Analyst roles
-Concentrates on remote positions with specified salaries
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/
/*
Taking queries 3 and 4, then creating them as CTEs
Removed order by to speed up the query
Removed limit because we want to combine the two tables
Added skill id to combine the results set
Group by adjusted to skill id to confirm that the aggregate is correct
Added a where clause with the demand count because previously we were receiving
    data that wasn't representative
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'San Francisco, CA'
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) as average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'San Francisco, CA'
    GROUP BY
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC,
    average_salary DESC
LIMIT 25

--Concise version of the query above
SELECT
    skills_dim.skill_id AS skillId,
    skills_dim.skills AS skill,
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'San Francisco, CA' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skillId
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    demand_count DESC,
    average_salary DESC
LIMIT 25;

