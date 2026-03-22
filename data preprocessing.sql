SELECT
	ROW_NUMBER() OVER(ORDER BY s.student_id, s.track_id DESC) AS student_track_id,
    s.student_id,
    i.track_name,
    s.date_enrolled,
    CASE WHEN s.date_completed IS NULL THEN 0 ELSE 1 END AS track_completed,
    DATEDIFF(s.date_completed, s.date_enrolled) AS days_for_completion,
    CASE
		WHEN DATEDIFF(s.date_completed, s.date_enrolled) = 0 THEN "Same day"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) BETWEEN 1 AND 7 THEN "1 to 7 days"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) BETWEEN 8 AND 30 THEN "8 to 30 days"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) BETWEEN 31 AND 60 THEN "31 to 60 days"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) BETWEEN 61 AND 90 THEN "61 to 90 days"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) BETWEEN 91 AND 365 THEN "91 to 365 days"
        WHEN DATEDIFF(s.date_completed, s.date_enrolled) > 365 THEN "365+ days"
	END AS completion_bucket
FROM
	career_track_student_enrollments s
    LEFT JOIN
    career_track_info i ON s.track_id = i.track_id