**How to make Xaringan presentations in R**

You can use this .Rproject as a template to create .html presentations with the Xaringan R Markdown extension by Yihui Xie.

About a year ago I started using R Markdown and Xaringan to prepare presentation and I love it! I would not want to go back to keynote, powerpoint etc.

Efficient, elegant, saves disk space and allows you you to easily prepare slides with a very consistent layout and style.

You can first have a look at an example html presentation here:
https://jekelylab.github.io/Presentation_template.html


If you would like to create presentations using this template, read on.

You can find an introduction to Xaringan here:
https://bookdown.org/yihui/rmarkdown/xaringan.html

Installation:
https://www.rdocumentation.org/packages/xaringan/versions/0.13

A tutorial with templates:
https://www.favstats.eu/post/xaringan_tut/

Here is another Xaringan template:
https://www.rostrum.blog/2019/05/24/xaringan-template/

For extra features including panels in slides or editable slides use XaringanExtra: 
https://pkg.garrickadenbuie.com/xaringanExtra/#/?id=xaringanextra

To reload slides on change use the Infinite Moon Reader addIn: https://www.rdocumentation.org/packages/xaringan/versions/0.26/topics/infinite_moon_reader


To start with my template, you can download this repository and edit in R. You could do this e.g., by opening Rstudio then File -> New Project -> Version Control -> Git 
under repository URL write https://github.com/JekelyLab/Xaringan_presentation_template/ and select a local folder for the project then press 'Create project'.

You can now open and edit the Presentation_template.Rmd file. You may need to install some packages, including Xaringan and XaringanExtra. 

Instructions here:
https://www.rdocumentation.org/packages/xaringan/versions/0.13
https://pkg.garrickadenbuie.com/xaringanExtra/#/?id=xaringanextra

The advantage of using an .Rproject is that you only need to define relative paths and not absolute paths. Makes life easier.
Store images for your presentation in /assets/img, videos in /assets/movies, html files in /assets/movies etc.

The style is defined in the css file /addons/xaringan-themer-GJ.css.
You can modify this file to change e.g., font colour or font size or the ratio of columns.

The template presentation shows examples of pre-defined image placements in one or two columns and also shows examples of placing images at any desired position in the slide.

Some example videos are also inserted either from the local /assets/movies folder or from the web.

For best performance, use .webm format. It is easy to convert other video formats to .webm with the ffmpeg program by running the command:
ffmpeg -i input_video.mov -f webm output_video.webm

I also added a slide in interactive html format. This shows a network that the presenter can interact with.

I added an editable slide and a slide with panels.

In my experience Google Chrome shows the best performance in playing the html slideshows, especially ones with several movies.

If you give a lot of presentations like I do then you can save a lot of disk-space by simply re-inserting the same images and videos from /assets/ into different presentations.
This is much better than saving individual keynote or powerpoint presentations.
To further save on disk space, you can delete the html file and the folder that is generated when you knit the .Rmd file. You can always regenerate these files by knitting your markdown file.

Enjoy!

https://qoto.org/@jekely

