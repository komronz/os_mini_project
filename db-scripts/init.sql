CREATE TABLE Timetable (
    id serial PRIMARY KEY,
    course_name VARCHAR(255),
    day VARCHAR(50),
    time VARCHAR(50),
    room VARCHAR(50),
    level INT
);

INSERT INTO Timetable (id, course_name, day, time, room, level) VALUES
(1, 'Computer Languages', 'Monday', '02:00p - 04:20p', 'Room 114', 3),
(2, 'Computer and Information', 'Thursday', '04:30p - 06:50p', 'Room 114', 3),
(3, 'Introduction to', 'Friday', '02:00p - 04:20p', 'Room 409', 3),
(4, 'Global Social Problems', 'Monday', '07:00p - 09:20p', 'Room 108', 3),
(5, 'Operating Systems', 'Monday', '04:30p - 06:50p', 'Room 304', 3),
(6, 'Culture and Communication', 'Friday', '04:30p - 06:50p', 'WebNet+', 3);
