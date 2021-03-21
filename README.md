# Time-Varying Pricing May Increase Total Electricity Consumption: Evidence from Costa Rica


_[Tabaré Capitán](http://tabarecapitan.com/), Francisco Alpízar, Róger Madrigal-Ballestero,
Subhrendu K. Pattanayak_

<!-- FIX LINK TO PAPER -->
We provide this repository to complement our [research article](https://www.tabarecapitan.com/assets/papers/CNFL_202103_compressed.pdf). We cannot include the raw data, but we include the code to run the analyses reported in the article.


## Materials

We obtained consumption data directly from the Compañía Nacional de Fuerza y Luz (CNFL), an electric utility in Costa Rica. As requested by the CNFL, we signed a confidentiality agreement (available upon request) that prevents us from sharing the data used in this research. We direct researchers to contact the CNFL if interested in the same or similar data [(www.cnfl.go.cr)](www.cnfl.go.cr). We know consumption data before 2011 exists, but it is in an external device, in an unknown format, and not connected to their current system. In addition, to our knowledge, the CNFL does not collect data about their customer (such as household size and others).


## Code

We use Stata 14.2 (SE) to conduct all analyses. The file `main.do` controls the execution of the rest of the files. [This](https://raw.githubusercontent.com/tabareCapitan/CNFL/master/code/code.jpg) old photo of the design for the data cleaning helps to understand the flow of the code. To run `main.do`, a specific folder structure is assumed (see *Replication instructions* below).

In `./code/`:

- `main.do`
  - `settings.do`
  - `installNewPrograms.do`
  - `importData.do`
  - `createPanels.do`
    - `clean.do`
  - `appendAll.do`
  - `deleteOutliers.do`
  - `createStataPanels.do`
  - `tagContractType.do`
  - `paper.do`
  - `counterfactualBilling.do`
  - `extras.do`

## Replication instructions

We want our work to be replicated. To that end, we include **one** script to replicate our research. The easiest way to replicate is to download the repository, edit  `main.do`, and run `main.do` (assuming the right software is installed and the raw data from the CNFL is obtained).<sup id="a1">[ 1](#f1)</sup>

### Required software
- Stata (we used SE 14.2)

### Required folder structure
```bash
CNFL (repository)
├── data
│   └── raw
│       └── [CNFL private data in .xlsx or .xls]
│   └── temp
├── code
│   ├── main.do
│   ├── installNewPrograms.do
│   └── ...
└── figures
    └── temp
```

### Editing `run.do`

- In line 21, add your local path to global macro `RUTA`

## Citation

[To be updated once we publish the paper]

## Questions?

- Open github issue
- Send me an email

---
## Footnotes

<b id="f1">1.</b> This project started a long time ago (back in 2015), I no longer follow the workflow used in this project. If you are looking for inspiration for your own workflow, I recommend [this guide](https://julianreif.com/guide/), which I have adapted and used in some of my newer work [(for example this one)](https://github.com/tabareCapitan/endowmentEffectInfo). [↩](#a1)
