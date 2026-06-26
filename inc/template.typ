/*
  Template for technical note (or paper)
  https://github.com/ckunte/note
  2026 C Kunte
*/

#let note(
  title: none,
  subtitle: none,
  author: none,
  paper: "a4",
  body,
) = {

  // ------------------------------------------------------------
  // State: running header (level 1 heading)
  // ------------------------------------------------------------

  let h1-state = state("h1", none)

  show heading.where(level: 1): it => {
    h1-state.update(it)
    it
  }

  // ------------------------------------------------------------
  // Page setup (Typst handles margins internally)
  // ------------------------------------------------------------

  set page(
    paper: paper,
    numbering: "1",

    header: context {
      let page-num = counter(page).get().first()

      if page-num <= 1 {
        return
      }

      if calc.even(page-num) {
        emph(title)
      } else {
        let current = h1-state.get()

        if current != none {
          align(right, emph(current.body))
        }
      }
    },
  )

  // ------------------------------------------------------------
  // Typography
  // ------------------------------------------------------------

  set text(
    font: "Segoe UI",
    size: if paper == "a5" { 10pt } else { 11pt },
    top-edge: "cap-height",
    bottom-edge: "baseline",
    number-type: "old-style",
  )

  set par(
    spacing: 0.65em,
    leading: 0.65em,
    first-line-indent: 12pt,
    justify: true,
  )

  // ------------------------------------------------------------
  // Raw / code blocks
  // ------------------------------------------------------------

  show raw: set text(size: 8pt, font:"JetBrains Mono")

  show raw.where(block: true): it => {
    set par(first-line-indent: 0pt)

    block(
      fill: luma(240),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      it,
    )
  }

  show raw.where(block: false): it => box(
      fill: luma(245),
      stroke: 0.5pt + luma(200),
      inset: (x: 3pt, y: 0pt),
      outset: (x: -1pt, y: 3pt),
      radius: 2pt,
      it,
    )

  // ------------------------------------------------------------
  // Small caps acronyms
  // ------------------------------------------------------------

  // show regex("[A-Z]{2,}"): it => text(features: ("c2sc",))[#it]

  // ------------------------------------------------------------
  // Tables
  // ------------------------------------------------------------

  show figure.where(kind: table): set figure.caption(position: top)

  set table(
    stroke: none,
    row-gutter: -0.5em,
  )

  show figure.caption: emph

  // Equation numbers
  //
  // // set math.equation(numbering: "(1)")
  // show math.equation: set block(spacing: 0.65em)
  // // Configure appearance of equation references
  // show ref: it => {
  //   if it.element != none and it.element.func() == math.equation {
  //     // Override equation references.
  //     link(it.element.location(), numbering(
  //       it.element.numbering,
  //       ..counter(math.equation).at(it.element.location())
  //     ))
  //   } else {
  //     // Other references as usual.
  //     it
  //   }
  // }

  // ------------------------------------------------------------
  // Links
  // ------------------------------------------------------------

  let colours = (
    cite: maroon,
    ref: rgb(0, 0, 128),
    link: rgb(0, 0, 255),
  )

  show cite: set text(fill: colours.cite)
  show ref: set text(fill: colours.ref)

  show link: set text(fill: colours.link)
  show link: underline

  // ------------------------------------------------------------
  // Editorial markers
  // ------------------------------------------------------------

  show regex("tb[acdu]"): set text(fill: red, style: "italic")

  // ------------------------------------------------------------
  // Quotes
  // ------------------------------------------------------------

  set quote(block: true)
  show quote: set text(style: "italic")

  // ------------------------------------------------------------
  // Title block
  // ------------------------------------------------------------

  align(center)[
    #text(1.8em)[*#title*]

    #if subtitle != none {
      v(1em, weak: true)
      text(1em)[_ #subtitle _]
    }

    #v(2em, weak: true)

    #text(1em)[#author]

    #v(1em, weak: true)

    #text(1em)[
      #datetime.today().display("[month repr:long] [day], [year]")
    ]

    #v(5em, weak: true)
  ]

  // ------------------------------------------------------------
  // Body
  // ------------------------------------------------------------

  body
}
/*

// for main.typ ->

#import "template.typ": *

#show: note.with(
  paper: "a5",
  logo: "logo.svg",
  title: [A Technical Note],
  subtitle: [A short subtitle],
  author: "C Kunte",
)

= Introduction

Your content here-on.

*/
