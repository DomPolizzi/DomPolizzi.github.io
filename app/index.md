---
layout: resume
title: Dominic Polizzi
subtitle: Engineer & Technology Professional
description: Resume of Dominic Polizzi
featured_image: /images/site-assets/sidebar-4.jpg
permalink: /
---

{% assign resume_page = site.pages | where: "name", "resume.md" | first %}
{{ resume_page.content }}
