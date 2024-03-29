CREATE TABLE "backers" (
    "backer_id" varchar(5)   NOT NULL,
    "cf_id" int   NOT NULL,
    "first_name" varchar(20)   NOT NULL,
    "last_name" varchar(20)   NOT NULL,
    "email" varchar(50)   NOT NULL,
    CONSTRAINT "pk_backers" PRIMARY KEY (
        "backer_id"
     )
);

-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
SELECT cf_id, 
    backers_count
FROM campaign
WHERE outcome = 'live'
ORDER BY backers_count DESC

-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.
SELECT b.cf_id, 
    count(b.backer_id)
FROM backers as b
INNER JOIN campaign as c
    ON (c.cf_id = b.cf_id)
WHERE c.outcome = 'live'
GROUP BY b.cf_id
ORDER BY COUNT(b.backer_id) DESC

-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 
SELECT 
    co.first_name, 
    co.last_name, 
    co.email,
    SUM(c.goal - c.pledged) AS "Remaing Amount"
INTO remaining_contacts_amount
FROM contacts AS co
INNER JOIN campaign AS c
    ON (c.contact_id=co.contact_ID)
WHERE c.outcome = 'live'
GROUP BY co.first_name, co.last_name, co.email
ORDER BY "Remaing Amount" DESC

-- Check the table
SELECT *
FROM remaining_contacts_amount

-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 
SELECT 
    b.email, 
    b.first_name, 
    b.last_name, 
    b.cf_id,
    c.company_name, 
    c.description, 
    c.end_date,
    SUM(c.goal - c.pledged) AS "Left of Goal"
INTO email_backers_remaining_goal_amount
FROM backers AS b
INNER JOIN campaign AS c
    ON (c.cf_id = b.cf_id)
GROUP BY b.email, b.first_name, b.last_name, b.cf_id, c.company_name, c.description, c.end_date
ORDER BY b.email DESC

-- Check the table
SELECT *
FROM email_backers_remaining_goal_amount