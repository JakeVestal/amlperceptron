# iris_info_tab.R
# by Jake Vestal
# 
# Returns the content of the "Understanding the Iris Dataset" tab in HTML
#   inside a div with id = "iris_info_tab".

div(
  id = "iris_info_tab",
  h2("The Iris Dataset"),
  p(
    code("iris"),
    " is a staple within the data community, (especially the R crowd) ",
    "because the concreteness of the subject matter, the modest number ",
    "of observations (150), and the seperability of the data points make",
    " the dataset a handy resource for development, testing, and ",
    "teaching. Nevertheless, only a few users of ", code("iris"),
    " would be able to answer correctly if asked what a \"sepal\" is, or",
    " what a \"versicolor\" looks like (although many have wondered). ",
    "Hopefully, the info in this tab answers those questions."
  ),
  hr(),
  h2("Sepals & Petals, and the Three ", code("Iris"), " Species"),
  p(
    strong("Sepals"),
    " are the tough outer wrapping of flower buds while the ",
    "flower is developing. In most plants, the sepals wither off or ",
    "become vestigial once the flower blooms, but in irises, they ",
    "remain as prominent features.",
    br(), br(),
    strong("Petals,"),
    " on the other hand, develop ", em("inside"), " a growing bud and ",
    "are considered part of the flower proper after blooming.",
    br(), br(),
    "The picture below, which depicts the three species of iris in ",
    code("iris"),
    " and indicates petal & sepal length & width, is taken from ", 
    a(
      "Suruchi Fialoke\'s wepbage ",
      href = "http://suruchifialoke.com/2016-10-13-machine-learning-tutorial-iris-classification/"
    ),
    " on this topic.",
    br(), br(),
    strong("Note how similar the 3 species of irises appear. "),
    "It's easy to see why Ronald Fisher, the biologist/statistician who ",
    "published ", code("iris"), "was interested in developing a way to ",
    "mathematically discern between these three species."
  ),
  img(
    src='irises.png', 
    alt = "irises",
    style="width:100%;"
  ),
  hr(),
  h2("More on ", code("Iris"), " via Wikipedia:"),
  htmlOutput("iris_dataset_wiki_frame")
)