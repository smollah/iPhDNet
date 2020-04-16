#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 13 21:43:34 2020

@author: compssd1
"""

import cmapPy.pandasGEXpress.parse

in_out = [
    ('LINCS_GCP_Plate27_annotated_minimized_2016-04-14_14-24-09.gct',
     "60histon_24hr_final.txt"),
    ('LINCS_GCP_Plate27_annotated_minimized_2016-04-14_14-24-09.gct',
     "60histon_24hr.txt"),
    ("LINCS_P100_PRM_Plate29_24H_annotated_minimized_2016-01-28_17-11-22.gct",
     "peptide_24hr_final.txt")
]

for in_, out in in_out:
    df = cmapPy.pandasGEXpress.parse.parse(in_).data_df
    df = df.apply(lambda x: x.fillna(x.mean()),axis=0)
    df.to_csv(out,sep="\t")


