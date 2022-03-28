DROP TABLE IF EXISTS retirement_titles CASCADE;
DROP TABLE IF EXISTS unique_titles CASCADE;
DROP TABLE IF EXISTS retiring_titles CASCADE;
DROP TABLE IF EXISTS mentorship_eligibilty CASCADE;

--Find Retirement individuals, including all roles
SELECT employees.emp_no, employees.first_name, employees.last_name, titles.title, titles.from_date, titles.to_date
	INTO retirement_titles
	FROM titles
	INNER JOIN employees ON employees.emp_no = titles.emp_no
	WHERE employees.birth_date BETWEEN '1952/01/01' AND '1955/12/31' 
	ORDER BY employees.emp_no, titles.from_date DESC;
--Find Retirement individuals, only including last position held
SELECT DISTINCT ON (employees.emp_no) employees.emp_no, employees.first_name, employees.last_name, titles.title
	INTO unique_titles
	FROM titles
	INNER JOIN employees ON employees.emp_no = titles.emp_no
	WHERE employees.birth_date BETWEEN '1952/01/01' AND '1955/12/31' 
	ORDER BY employees.emp_no, titles.from_date DESC;

-- number of current employees ready to retire. 
SELECT count(unique_titles.title), unique_titles.title
	INTO retiring_titles
	FROM unique_titles
	INNER JOIN titles ON unique_titles.emp_no = titles.emp_no
	WHERE titles.to_date BETWEEN '9998/12/31' AND '9999/01/02'
	GROUP BY unique_titles.title
	ORDER BY count(unique_titles.title) DESC;
	
-- Mentorship Program
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, d.from_date, d.to_date, titles.title
	INTO mentorship_eligibilty
	FROM employees AS e
	INNER JOIN dept_employees AS d
	ON e.emp_no = d.emp_no
	INNER JOIN titles 
	ON titles.emp_no = d.emp_no
	WHERE titles.to_date BETWEEN '9998/12/31' AND '9999/01/02' AND e.birth_date BETWEEN '1965/01/01' AND '1965/12/31'
	ORDER BY e.emp_no;
	
--Mentership Program Count 
SELECT count(title),title 
--	INTO mentoring_titles
	FROM mentorship_eligibilty
	GROUP BY title
	ORDER BY count(title) DESC;