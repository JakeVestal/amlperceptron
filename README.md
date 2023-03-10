# AML Perceptron

This Shiny app demonstrates how a simple binary perceptron works.




## How to View
At a minimum, you will need to have R installed on your computer. Installing Git
and RStudio is recommended, but not necessary.

<b>Installing Git:</b> https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

<b>Installing R:</b> http://archive.linux.duke.edu/cran/

<b>Installing RStudio:</b> https://www.rstudio.com/products/rstudio/download/

### Using Only R
If you only have R installed on your computer and don't wish to install git or 
RStudio, you can view the app by completing the following steps:
<ol>
<li>Download the repo to your computer (as a .zip, .tar, etc)</li>
<li>Extract the download to a location of your choice</li>
<li>Start an R session</li>
<li>In the R terminal, navigate to the extracted folder using command: 
<code>setwd("[<i>YOUR DIRECTORY</i>]/personality-pcoa-master/")</code> 
where "[<i>YOUR DIRECTORY</i>]" is the location you extracted the repo. If you 
did it right, you should see the files from the repository listed in the 
command's output.</li>
<li>Enter command: <code>source(".Rprofile")</code></li>
<li>Enter command: <code>packrat::restore()</code></li>
<li>Enter command: <code>shiny::runApp()</code></li>
</ol>

### Using RStudio
<ol>
<li> Clone or download the repo</li>
<li> Open the .RProject file in RStudio (if you cloned the repo within RStudio
and checked the "Open in New Session" box, this step is already done)</li>
<li>Enter command: <code>packrat::restore()</code></li>
<li>Open the app.R file by clicking it in the File Explorer window on the lower
right-hand corner of RStudio</li>
<li> Click the <b>Run App</b> button with the green arrow</li>
</ol>
