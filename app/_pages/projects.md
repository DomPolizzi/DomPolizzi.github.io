---
layout: default
title: Projects
subtitle: Personal Endeavours 
description: Portfolio of technical projects and achievements
featured_image: /images/site-assets/sidebar-3.jpg
---

<section class="intro">

	<div class="wrap">

		<h1>{{ page.title }}</h1>
		<p>{{ page.subtitle }}</p>

	</div>

</section>

<section class="projects-list">

	<div class="wrap">

		{% for project in site.projects reversed %}

		<div class="project-item" style="display: flex; align-items: flex-start; margin-bottom: 40px; padding: 20px; background: #1E1E1E; border-radius: 8px; transition: background 0.2s ease;">

			<a href="{{ project.url | relative_url }}" style="display: flex; align-items: flex-start; text-decoration: none; width: 100%;">

				<div class="project-thumbnail" style="width: 120px; height: 80px; background-image: url({{ project.featured_image | relative_url }}); background-size: cover; background-position: center; border-radius: 6px; margin-right: 20px; flex-shrink: 0;"></div>

				<div class="project-content" style="flex: 1;">
					<h2 class="project-title" style="color: #E0E0E0; font-size: 22px; margin-bottom: 8px; font-weight: 600;">{{ project.title }}</h2>
					{% if project.description %}
					<p class="project-description" style="color: #A8A8A8; font-size: 16px; line-height: 1.5; margin: 0;">{{ project.description | truncate: 200 }}</p>
					{% endif %}
				</div>

			</a>

		</div>

		{% endfor %}

	</div>

</section>

{% if paginator.total_pages > 1 %}

<section class="pagination">

	{% if paginator.previous_page %}
	<div class="pagination__prev">
		<a href="{{ paginator.previous_page_path | relative_url }}" class="button button--large"><i class="fa fa-angle-left" aria-hidden="true"></i> <span>Newer Posts</span></a>
	</div>
	{% endif %}
	{% if paginator.next_page %}
	<div class="pagination__next">
		<a href="{{ paginator.next_page_path | relative_url }}" class="button button--large"><span>Older Posts</span> <i class="fa fa-angle-right" aria-hidden="true"></i></a>
	</div>
	{% endif %}

</section>

{% endif %}
