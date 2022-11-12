# Xaringan_presentation_template

You can use this .Rproject as a template to create .html presentations with the Xaringan R package

About a year ago I started using R Markdown and the Xaringan package to prepare presentation and I love it! I would not want to go back to keynote and powerpoint.

Efficient, elegant, saves disk space and allows you you to easily prepare slides with a very consistent layout.

more on Xaringan here:
https://bookdown.org/yihui/rmarkdown/xaringan.html

You can download the repository and edit in R or open Rstudio then File -> New Project -> Version Control -> Git 
under repository URL write https://github.com/JekelyLab/Xaringan_presentation_template/ and select a local folder for the project then press 'Create project'.

You can now open and edit the Presentation.Rmd file. You may need to install some packages, including Xaringan. 
Instructions here:
https://www.rdocumentation.org/packages/xaringan/versions/0.13

Store images for the presentation in /assets/img, videos in /assets/movies, html files in /assets/movies.

The style is defined in the css file /addons/xaringan-themer-GJ.css.
You can modify this file to change e.g., font colour or font size or the ratio of columns.

The template presentation shows examples of pre-defined image placements in one or two columns and also shows examples of placing images at any desired position in the slide.

Some example videos are also inserted either from the local /assets/movies folder or from the web.
For best performance, use .webm format. It is easy to convert other video formats to .webm with the ffmpeg program by running the command
ffmpeg -i input_video.mov -f webm output_video.webm

I also added a slide in interactive html format. This shows a network that the presenter can interact with.

I added an editable slide and a slide with tabs.

In my experience Google Chrome shows the best performance in playing the html slideshow, especially when it has several movies.

If you give a lot of presentations like I do then you can save a lot of disk-space by simply re-inserting the same images and videos from /assets/ into different presentations.
This is much better than saving individual keynote or powerpoint presentations.
To further save disk space, you can delete the html file and the folder that is generated when you knit the .Rmd file. You can always regenerate these files by knitting your markdown file.

Enjoy!

https://qoto.org/@jekely

