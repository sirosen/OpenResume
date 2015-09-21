OpenResume
===

A Resume Maintenance Toolkit

What is it?
---

This project contains templating tools to help me maintain my resume, and
(hopefully) to help others manage their resumes or CVs.

The basic idea is that if resume content is kept in a format like JSON or XML,
then it can be rendered to multiple presentation formats.
The further content is kept from finicky systems like TeX rendering and CSS
styling, the less chance that I give in to temptation and compromise content in
order to satisfy those systems.

MIT Licensed
---

Because no one wants to have questions about the licensing of their own resume.

How to Use It?
---

Your resume is JSON, and `make all` renders it to PDF, PNG, and HTML (and also
TeX) output in `output/`.
Fork to change the content, feel free to alter the source to support
customizations you need.

I use JQuery to include the resulting HTML on my website, and I recommend doing
the same if you want to embed the HTML elsewhere.
