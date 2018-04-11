KoSpacing 
---------------

R package for automatic word spacing.


[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)


#### Introduction

Word spacing is one of the important parts of the preprocessing of Korean text analysis. Accurate spacing greatly affects the accuracy of subsequent text analysis. `KoSpacing` can help fairly accurate automatic word spacing performance, especially good for online text originated from SNS.

`KoSpacing` based on Deep Learning model trained from large corpus(more than 100 million NEWS articles from [Chan-Yub Park](https://github.com/mrchypark). 


#### Performance

| Test Set  | Accuracy | 
|---|---|
| Sejong(colloquial style) Corpus(1M) | 97.1% |
| OOOO(literary style)  Corpus(3M)   | 94.3% |

- Accuracy = # correctly spaced characters/# characters in the test data.


#### Install

To install from GitHub, use

    install.packages(c('tensorflow', 'keras', 'hashmap', 'reticulate'))
    install.packages('devtools')
    devtools::install_github('haven-jeon/KoSpacing')


#### Citation

```markdowns
@misc{heewon2018,
author = {Heewon Jeon},
title = {Automatic Korean word spacing with R},
publisher = {GitHub},
journal = {GitHub repository},
howpublished = {\url{https://github.com/haven-jeon/KoSpacing}}
```

#### Model Architecture

![](arch.png)




