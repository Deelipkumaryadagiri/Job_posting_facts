--List all skills
SELECT skill_id, skills, type
FROM public.skills_dim;

--Job title with company name
SELECT 
    j.job_id,
    j.job_title,
    c.name AS company_name,
    j.job_location
FROM public.job_postings_fact j
JOIN public.company_dim c
ON j.company_id = c.company_id;

--Jobs with required skills
SELECT 
    j.job_title,
    s.skills
FROM public.job_postings_fact j
JOIN public.skills_job_dim sj ON j.job_id = sj.job_id
JOIN public.skills_dim s ON sj.skill_id = s.skill_id;

--Work-from-home jobs
SELECT job_title, job_location
FROM public.job_postings_fact
WHERE job_work_from_home = TRUE;

--Average yearly salary by job title
SELECT 
    job_title_short,
    AVG(salary_year_avg) AS avg_salary
FROM public.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
ORDER BY avg_salary DESC;

--Most demanded skills
SELECT 
    s.skills,
    COUNT(sj.job_id) AS demand_count
FROM public.skills_dim s
JOIN public.skills_job_dim sj
ON s.skill_id = sj.skill_id
GROUP BY s.skills
ORDER BY demand_count DESC;

--Jobs with salary above average
SELECT job_title, salary_year_avg
FROM public.job_postings_fact
WHERE salary_year_avg >
      (SELECT AVG(salary_year_avg)
       FROM public.job_postings_fact);

--The most in-demand skills in the job market
SELECT 
    s.skills,
    COUNT(sj.job_id) AS demand_count
FROM public.skills_dim s
JOIN public.skills_job_dim sj
ON s.skill_id = sj.skill_id
GROUP BY s.skills
ORDER BY demand_count DESC;

--Jobs posted in the last 30 days
SELECT 
    job_title,
    job_posted_date
FROM public.job_postings_fact
WHERE job_posted_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY job_posted_date DESC;
