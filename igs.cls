\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{igs}

\newif\if@reviewmode\@reviewmodefalse
\newif\if@aog\@aogfalse
\newif\if@jog\@jogfalse
\DeclareOption{review}{\@reviewmodetrue}
\DeclareOption{jog}{\@jogtrue}
\DeclareOption{aog}{\@aogtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\if@reviewmode
  \LoadClass[11pt]{article}
\else
  \LoadClass[10pt,twoside]{article}
\fi

\RequirePackage[T1]{fontenc}

\RequirePackage{lineno}
\RequirePackage{setspace}
\RequirePackage{amsmath}
\RequirePackage{xpatch}

\RequirePackage[left=13.6mm,textwidth=178mm,top=20mm,textheight=61em,columnsep=6mm,marginparwidth=2.2pc,marginparsep=0.5pc,headsep=1.5em,headheight=14pt,letterpaper]{geometry}
\RequirePackage{footmisc}
\RequirePackage{caption}
\DeclareCaptionJustification{double}{\doublespacing}
\DeclareCaptionLabelSeparator{dotquad}{.\quad}
\RequirePackage[explicit]{titlesec}
\RequirePackage[style]{abstract}
\RequirePackage{fancyhdr}

\if@reviewmode
  \RequirePackage{lmodern}
  \RequirePackage{amssymb,amsbsy}
  \linenumbers
  \doublespacing
  \let\oldmarginpar\marginpar
  \renewcommand{\marginpar}[1]{\oldmarginpar{\itshape\footnotesize #1}}
  \renewcommand{\footnotelayout}{\footnotesize\doublespacing}
  \patchcmd{\thanks}{#1}{\protect\doublespacing\footnotesize#1}{}{}
  \xapptocmd{\table}{\doublespacing\small}{}{}
  \xapptocmd{\figure}{\doublespacing}{}{}
  \AtBeginEnvironment{tabular}{\small\doublespacing}{}{}
\else
  \RequirePackage{libertine}
  \renewcommand*\familydefault{\sfdefault}
  \renewcommand{\ttdefault}{lmtt}
  \RequirePackage{newtxsf}
  \twocolumn
  \renewcommand{\marginpar}[1]{}
\fi

\RequirePackage{upgreek}

\RequirePackage{environ}
\NewEnviron{frontmatter}{%
  \if@reviewmode\BODY
  \else\twocolumn[\BODY]\saythanks\fi
}

\renewcommand{\title}[2][]{%
  \def\@shorttitle{#1}
  \def\@title{#2}
}

\renewcommand{\author}[2][]{%
  \def\@shortauthor{#1}
  \def\@author{#2}
}

\newcommand{\jourvolume}[1]{\def\@volume{#1}}
\newcommand{\jourissue}[1]{\def\@issueno{#1}}
\newcommand{\jourpubyear}[1]{\def\@pubyear{#1}}

\def\@shortauthor{}
\def\@shorttitle{}
\def\@journal{}
\def\@volume{00}
\def\@issueno{0}
\def\@pubyear{0000}


\newcommand{\email}[1]{<#1>}

\newcommand{\affiliation}[1]{\def\@affil{#1}}

\renewcommand{\@maketitle}{%
  \null\vspace*{-8pt}%
  \begingroup\centering
  {\bfseries\LARGE\@title\par}
  \vskip12pt plus 2pt minus 1pt
  {\large\@author\par}
  \vskip8pt plus 1pt
  {\itshape\@affil\par}
  \vspace{5pt plus 2pt minus 1pt}
  \par
  \endgroup%
}

\renewcommand{\abstitlestyle}[1]{}
\setlength{\absleftindent}{14mm}
\setlength{\absrightindent}{14mm}
\setlength{\absparindent}{0pt}
\renewcommand{\abstracttextfont}{\noindent\bfseries ABSTRACT.\space}
\apptocmd{\abstract}{\ignorespaces}{}{}
\apptocmd{\endabstract}{\vskip30pt plus 10pt minus 2pt}{}{}

\if@aog
  \def\@journal{Annals of Glaciology \@volume (\@issueno) \@pubyear}
\fi
\if@jog
  \def\@journal{Journal of Glaciology, Vol.\ \@volume, No.\ \@issueno, \@pubyear}
\fi

\setcounter{secnumdepth}{0}
\titleformat{\section}
  {\large\bfseries\raggedright}
  {\thesection}
  {0pt}
  {\MakeUppercase{#1}}

\titleformat{\subsection}
  {\large\bfseries\raggedright}
  {\thesubsection}
  {0pt}
  {#1}
  
\titleformat{\subsubsection}
  {\itshape\raggedright}
  {\thesubsubsection}
  {0pt}
  {#1}

\if@reviewmode
  \captionsetup*{font=small,labelfont=bf,labelsep=dotquad,justification={justified,doublespacing},singlelinecheck=false}
\else
  \captionsetup*{font=small,labelfont=bf,labelsep=dotquad,justification=justified,singlelinecheck=false}
\fi
\renewcommand{\figurename}{Fig.}

\RequirePackage{enumitem}
\setlist[enumerate]{leftmargin=*}
\setlist[itemize]{label={}}

\RequirePackage{natbib}
\renewcommand{\bibfont}{\small}

\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\if@reviewmode
  \lhead{\footnotesize\itshape\@shortauthor: \@shorttitle}
  \rhead{\footnotesize\thepage}
\else
  \fancyhead[RE,LO]{\footnotesize\itshape\@shortauthor: \@shorttitle}
  \fancyhead[LE,RO]{\footnotesize\thepage}
\fi

\pagestyle{fancy}

\fancypagestyle{plain}{
  \lhead{\footnotesize\@journal}
}

% https://tex.stackexchange.com/questions/80104/how-to-get-an-upright-partial
\DeclareRobustCommand{\uppartial}{\text{\rotatebox[origin=t]{20}{\scalebox{0.95}[1]{$\partial$}}}\hspace{-1pt}}