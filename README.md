# Time-Varying Pricing May Increase Total Electricity Consumption: Evidence from Costa Rica


_[Tabaré Capitán](http://tabarecapitan.com/), Francisco Alpízar, Róger Madrigal-Ballestero,
Subhrendu K. Pattanayak_

<details>
  <summary>See abstract</summary>

  > We study the implementation of a time-varying pricing (TVP) program by a major electricity utility in Costa Rica. Because of particular features of the data, we use recently developed understanding of the two-way fixed effects differences-in-differences estimator along with event-study specifications to interpret our results. Similar to previous research, we find that the program reduces consumption during peak-hours. However, in contrast with previous research, we find that the program increases total consumption. With a stylized economic model, we show how these seemingly conflicted results may not be at odds. The key element of the model is that previous research used data from rich countries, in which the use of heating and cooling devices drives electricity consumption, but we use data from a tropical middle-income country, where very few households have heating or cooling devices. Since there is not much room for technological changes (which might reduce consumption at all times), behavioral changes to reduce consumption during peak hours are not enough to offset the increased consumption during off-peak hours (when electricity is cheaper). Our results serve as a cautionary piece of evidence for policy makers interested in reducing consumption during peak hours—the goal can potentially be achieved with TVP, but the cost is increased total consumption.
  >
  > _JEL codes_: Q41, Q47, Q50
  >  
  > _Keywords_: dynamic pricing, energy, behavioral adjustments, developing country

</details>

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
