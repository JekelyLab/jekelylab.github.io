library(openalexR)
library(dplyr)
library(ggplot2)


works_from_dois <- oa_fetch(
  entity = "works",
  doi = c("10.1016/j.joi.2017.08.007", "https://doi.org/10.1007/s11192-013-1221-3"),
  verbose = TRUE
)

works_from_dois

works_from_dois |>
  show_works() |>
  knitr::kable()


works_from_pmids <- oa_fetch(
  entity = "works",
  pmid = c("14907713", 32572199),
  verbose = TRUE
)
#> Requesting url: https://api.openalex.org/works?filter=pmid%3A14907713%7C32572199
#> Getting 1 page of results with a total of 2 records...
works_from_pmids |>
  show_works() |>
  knitr::kable()


works_search <- oa_fetch(
  entity = "works",
  title.search = c("Platynereis"),
  cited_by_count = ">50",
  from_publication_date = "2000-01-01",
  to_publication_date = "2024-12-31",
  options = list(sort = "cited_by_count:desc"),
  verbose = TRUE
)
#> Requesting url: https://api.openalex.org/works?filter=title.search%3Abibliometric%20analysis%7Cscience%20mapping%2Ccited_by_count%3A%3E50%2Cfrom_publication_date%3A2020-01-01%2Cto_publication_date%3A2021-12-31&sort=cited_by_count%3Adesc
#> Getting 2 pages of results with a total of 376 records...
works_search |>
  show_works() |>
  knitr::kable()


works_from_orcids <- oa_fetch(
  entity = "works",
  author.orcid = c("0000-0001-8496-9836"),
  cited_by_count = ">50",
  from_publication_date = "1995-01-01",
  to_publication_date = "2024-12-31",
  options = list(sort = "cited_by_count:desc"),
  verbose = TRUE
)
#> Details at https://docs.openalex.org/api-entities/authors/limitations.
works_from_orcids |>
  show_works() |>
  knitr::kable()

# Italian institutions ------------


italy_insts <- oa_fetch(
  entity = "institutions",
  country_code = "it",
  type = "education",
  verbose = TRUE
)
#> Requesting url: https://api.openalex.org/institutions?filter=country_code%3Ait%2Ctype%3Aeducation
#> Getting 2 pages of results with a total of 232 records...
italy_insts |>
  slice_max(cited_by_count, n = 8) |>
  mutate(display_name = forcats::fct_reorder(display_name, cited_by_count)) |>
  ggplot() +
  aes(x = cited_by_count, y = display_name, fill = display_name) +
  geom_col() +
  scale_fill_viridis_d(option = "E") +
  guides(fill = "none") +
  labs(
    x = "Total citations", y = NULL,
    title = "Italian references"
  ) +
  coord_cartesian(expand = FALSE)

# The package wordcloud needs to be installed to run this chunk
# library(wordcloud)
concept_cloud <- italy_insts |>
  select(inst_id = id, topics) |>
  tidyr::unnest(topics) |>
  filter(type == "field") |>
  select(display_name, count) |>
  group_by(display_name) |>
  summarise(score = sqrt(sum(count)))
pal <- c("black", scales::brewer_pal(palette = "Set1")(5))
set.seed(1)
wordcloud::wordcloud(
  concept_cloud$display_name,
  concept_cloud$score,
  scale = c(2, .4),
  colors = pal
)
