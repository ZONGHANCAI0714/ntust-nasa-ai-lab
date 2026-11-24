# M2 Stage A Data Quality Review

No rows are removed, no outliers are removed, and no missing values are imputed. Whitespace files cannot identify the position of an omitted token; short field counts are reported as malformed rows and a minimum missing-slot deficit.

| Split | Rows | Columns | Unique units | Cycle min | Cycle max | Missing-slot deficit | Blank lines | Full-row duplicates | Duplicate Unit-Cycle keys | Parse errors | Skipped cycles |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| TRAIN | 20631 | 26 expected | 100 | 1 | 362 | 0 | 0 | 0 | 0 | 0 | 0 |
| TEST | 13096 | 26 expected | 100 | 1 | 303 | 0 | 0 | 0 | 0 | 0 | 0 |

## Unit sequence length distribution

### TRAIN
- observations_per_unit=128: unit_count=1
- observations_per_unit=135: unit_count=1
- observations_per_unit=137: unit_count=2
- observations_per_unit=147: unit_count=2
- observations_per_unit=150: unit_count=1
- observations_per_unit=153: unit_count=1
- observations_per_unit=154: unit_count=2
- observations_per_unit=155: unit_count=1
- observations_per_unit=156: unit_count=2
- observations_per_unit=158: unit_count=3
- observations_per_unit=163: unit_count=2
- observations_per_unit=165: unit_count=1
- observations_per_unit=166: unit_count=1
- observations_per_unit=168: unit_count=1
- observations_per_unit=170: unit_count=2
- observations_per_unit=172: unit_count=1
- observations_per_unit=174: unit_count=1
- observations_per_unit=178: unit_count=1
- observations_per_unit=179: unit_count=1
- observations_per_unit=180: unit_count=2
- observations_per_unit=181: unit_count=1
- observations_per_unit=185: unit_count=3
- observations_per_unit=188: unit_count=3
- observations_per_unit=189: unit_count=1
- observations_per_unit=191: unit_count=1
- observations_per_unit=192: unit_count=2
- observations_per_unit=193: unit_count=1
- observations_per_unit=194: unit_count=2
- observations_per_unit=195: unit_count=4
- observations_per_unit=196: unit_count=1
- observations_per_unit=198: unit_count=1
- observations_per_unit=199: unit_count=3
- observations_per_unit=200: unit_count=2
- observations_per_unit=201: unit_count=1
- observations_per_unit=202: unit_count=3
- observations_per_unit=207: unit_count=2
- observations_per_unit=208: unit_count=1
- observations_per_unit=209: unit_count=1
- observations_per_unit=210: unit_count=1
- observations_per_unit=213: unit_count=5
- observations_per_unit=214: unit_count=2
- observations_per_unit=215: unit_count=1
- observations_per_unit=216: unit_count=1
- observations_per_unit=217: unit_count=1
- observations_per_unit=222: unit_count=1
- observations_per_unit=229: unit_count=1
- observations_per_unit=230: unit_count=1
- observations_per_unit=231: unit_count=3
- observations_per_unit=234: unit_count=2
- observations_per_unit=240: unit_count=2
- observations_per_unit=256: unit_count=1
- observations_per_unit=257: unit_count=1
- observations_per_unit=258: unit_count=1
- observations_per_unit=259: unit_count=1
- observations_per_unit=267: unit_count=1
- observations_per_unit=269: unit_count=1
- observations_per_unit=275: unit_count=1
- observations_per_unit=276: unit_count=1
- observations_per_unit=278: unit_count=1
- observations_per_unit=283: unit_count=2
- observations_per_unit=287: unit_count=1
- observations_per_unit=293: unit_count=1
- observations_per_unit=313: unit_count=1
- observations_per_unit=336: unit_count=1
- observations_per_unit=341: unit_count=1
- observations_per_unit=362: unit_count=1
### TEST
- observations_per_unit=31: unit_count=1
- observations_per_unit=34: unit_count=1
- observations_per_unit=37: unit_count=1
- observations_per_unit=39: unit_count=1
- observations_per_unit=46: unit_count=1
- observations_per_unit=48: unit_count=1
- observations_per_unit=49: unit_count=1
- observations_per_unit=50: unit_count=1
- observations_per_unit=54: unit_count=2
- observations_per_unit=55: unit_count=1
- observations_per_unit=56: unit_count=1
- observations_per_unit=68: unit_count=2
- observations_per_unit=71: unit_count=2
- observations_per_unit=72: unit_count=1
- observations_per_unit=73: unit_count=2
- observations_per_unit=74: unit_count=1
- observations_per_unit=76: unit_count=2
- observations_per_unit=78: unit_count=1
- observations_per_unit=83: unit_count=1
- observations_per_unit=88: unit_count=1
- observations_per_unit=89: unit_count=1
- observations_per_unit=94: unit_count=1
- observations_per_unit=97: unit_count=2
- observations_per_unit=98: unit_count=1
- observations_per_unit=101: unit_count=1
- observations_per_unit=105: unit_count=1
- observations_per_unit=106: unit_count=1
- observations_per_unit=110: unit_count=1
- observations_per_unit=112: unit_count=1
- observations_per_unit=113: unit_count=2
- observations_per_unit=121: unit_count=3
- observations_per_unit=123: unit_count=1
- observations_per_unit=125: unit_count=1
- observations_per_unit=126: unit_count=2
- observations_per_unit=130: unit_count=1
- observations_per_unit=131: unit_count=1
- observations_per_unit=133: unit_count=4
- observations_per_unit=134: unit_count=1
- observations_per_unit=135: unit_count=1
- observations_per_unit=136: unit_count=1
- observations_per_unit=137: unit_count=1
- observations_per_unit=140: unit_count=1
- observations_per_unit=143: unit_count=1
- observations_per_unit=144: unit_count=1
- observations_per_unit=145: unit_count=1
- observations_per_unit=146: unit_count=2
- observations_per_unit=147: unit_count=2
- observations_per_unit=148: unit_count=1
- observations_per_unit=150: unit_count=1
- observations_per_unit=152: unit_count=2
- observations_per_unit=155: unit_count=1
- observations_per_unit=156: unit_count=1
- observations_per_unit=158: unit_count=1
- observations_per_unit=159: unit_count=1
- observations_per_unit=160: unit_count=2
- observations_per_unit=162: unit_count=2
- observations_per_unit=164: unit_count=1
- observations_per_unit=165: unit_count=1
- observations_per_unit=166: unit_count=1
- observations_per_unit=168: unit_count=1
- observations_per_unit=171: unit_count=1
- observations_per_unit=172: unit_count=2
- observations_per_unit=176: unit_count=1
- observations_per_unit=177: unit_count=1
- observations_per_unit=184: unit_count=1
- observations_per_unit=186: unit_count=1
- observations_per_unit=187: unit_count=1
- observations_per_unit=189: unit_count=1
- observations_per_unit=192: unit_count=1
- observations_per_unit=195: unit_count=1
- observations_per_unit=196: unit_count=1
- observations_per_unit=198: unit_count=2
- observations_per_unit=203: unit_count=1
- observations_per_unit=205: unit_count=1
- observations_per_unit=213: unit_count=1
- observations_per_unit=217: unit_count=1
- observations_per_unit=232: unit_count=1
- observations_per_unit=234: unit_count=1
- observations_per_unit=244: unit_count=1
- observations_per_unit=303: unit_count=1

## Numeric ranges and variance screening

| Split | Column | Min | Max | Mean | Sample SD | Negative count | Constant | CV | Low-variance candidate (CV < 1%) |
|---|---|---:|---:|---:|---:|---:|---|---:|---|
| TRAIN | op_setting_1 | -0.0086999999999999994 | 0.0086999999999999994 | -8.8701468663661109E-06 | 0.002187313449015146 | 10061 | False | 246.59269817831512 | NO/NA |
| TRAIN | op_setting_2 | -0.00059999999999999995 | 0.00059999999999999995 | 2.3508312733265421E-06 | 0.00029306212456614502 | 9225 | False | 124.66318952420932 | NO/NA |
| TRAIN | op_setting_3 | 100 | 100 | 100 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_1 | 518.66999999999996 | 518.66999999999996 | 518.66999999999996 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_2 | 641.21000000000004 | 644.52999999999997 | 642.6809335466055 | 0.50005327006055933 | 0 | False | 0.00077807391500015117 | YES |
| TRAIN | sensor_3 | 1571.04 | 1616.9100000000001 | 1590.5231186079234 | 6.131149519690708 | 0 | False | 0.0038548006300322662 | YES |
| TRAIN | sensor_4 | 1382.25 | 1441.49 | 1408.9337816877489 | 9.0006047805437142 | 0 | False | 0.0063882383242752343 | YES |
| TRAIN | sensor_5 | 14.619999999999999 | 14.619999999999999 | 14.619999999999999 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_6 | 21.600000000000001 | 21.609999999999999 | 21.60980320876336 | 0.0013889849127084167 | 0 | False | 6.4275685404906676E-05 | YES |
| TRAIN | sensor_7 | 549.85000000000002 | 556.05999999999995 | 553.36771121129107 | 0.88509225766339183 | 0 | False | 0.0015994649484083092 | YES |
| TRAIN | sensor_8 | 2387.9000000000001 | 2388.5599999999999 | 2388.096651640722 | 0.070985478890557063 | 0 | False | 2.9724709358721758E-05 | YES |
| TRAIN | sensor_9 | 9021.7299999999996 | 9244.5900000000001 | 9065.2429407203053 | 22.082879525067685 | 0 | False | 0.0024359942330804238 | YES |
| TRAIN | sensor_10 | 1.3 | 1.3 | 1.3 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_11 | 46.850000000000001 | 48.530000000000001 | 47.541168145024301 | 0.26708739863969228 | 0 | False | 0.0056180234744115324 | YES |
| TRAIN | sensor_12 | 518.69000000000005 | 523.38 | 521.41347002084274 | 0.73755339220961891 | 0 | False | 0.0014145269246307278 | YES |
| TRAIN | sensor_13 | 2387.8800000000001 | 2388.5599999999999 | 2388.0961523920519 | 0.071918915697573582 | 0 | False | 3.0115586269646446E-05 | YES |
| TRAIN | sensor_14 | 8099.9399999999996 | 8293.7199999999993 | 8143.7527221171567 | 19.076175975950633 | 0 | False | 0.0023424306492193367 | YES |
| TRAIN | sensor_15 | 8.3248999999999995 | 8.5847999999999995 | 8.4421455818914115 | 0.0375050379519659 | 0 | False | 0.0044425954975729192 | YES |
| TRAIN | sensor_16 | 0.029999999999999999 | 0.029999999999999999 | 0.029999999999999999 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_17 | 388 | 400 | 393.21065387038846 | 1.5487630246142876 | 0 | False | 0.0039387616011157126 | YES |
| TRAIN | sensor_18 | 2388 | 2388 | 2388 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_19 | 100 | 100 | 100 | 0 | 0 | True | 0 | YES |
| TRAIN | sensor_20 | 38.140000000000001 | 39.43 | 38.816270660656279 | 0.18074642787365819 | 0 | False | 0.0046564604171739936 | YES |
| TRAIN | sensor_21 | 22.894200000000001 | 23.618400000000001 | 23.28970536086473 | 0.10825087474491285 | 0 | False | 0.0046480139214991585 | YES |
| TEST | op_setting_1 | -0.0082000000000000007 | 0.0077999999999999996 | -1.1178985949908421E-05 | 0.0022026850808076104 | 6470 | False | 197.03800422306239 | NO/NA |
| TEST | op_setting_2 | -0.00059999999999999995 | 0.00069999999999999999 | 4.2379352474038248E-06 | 0.00029403056709582817 | 5869 | False | 69.38061813850328 | NO/NA |
| TEST | op_setting_3 | 100 | 100 | 100 | 0 | 0 | True | 0 | YES |
| TEST | sensor_1 | 518.66999999999996 | 518.66999999999996 | 518.66999999999996 | 0 | 0 | True | 0 | YES |
| TEST | sensor_2 | 641.13 | 644.29999999999995 | 642.47508781307295 | 0.40089934207398492 | 0 | False | 0.00062399204214845126 | YES |
| TEST | sensor_3 | 1569.04 | 1607.55 | 1588.0992043372021 | 5.0032739301175333 | 0 | False | 0.0031504794640367976 | YES |
| TEST | sensor_4 | 1384.3900000000001 | 1433.3599999999999 | 1404.7353619425799 | 6.6883092929186345 | 0 | False | 0.0047612592906250382 | YES |
| TEST | sensor_5 | 14.619999999999999 | 14.619999999999999 | 14.619999999999999 | 0 | 0 | True | 0 | YES |
| TEST | sensor_6 | 21.600000000000001 | 21.609999999999999 | 21.609700671960866 | 0.001704084756048973 | 0 | False | 7.8857397514074142E-05 | YES |
| TEST | sensor_7 | 550.88 | 555.84000000000003 | 553.75752290775915 | 0.68128610959380165 | 0 | False | 0.0012302968021389487 | YES |
| TEST | sensor_8 | 2387.8899999999999 | 2388.3000000000002 | 2388.0709644166027 | 0.057441784144965521 | 0 | False | 2.4053633665362347E-05 | YES |
| TEST | sensor_9 | 9024.5300000000007 | 9155.0300000000007 | 9058.4073633170556 | 11.436260521347089 | 0 | False | 0.0012625023431447114 | YES |
| TEST | sensor_10 | 1.3 | 1.3 | 1.3 | 0 | 0 | True | 0 | YES |
| TEST | sensor_11 | 46.799999999999997 | 48.259999999999998 | 47.41620418448391 | 0.19591724531321894 | 0 | False | 0.0041318626972112055 | YES |
| TEST | sensor_12 | 519.38 | 523.75999999999999 | 521.74772373243695 | 0.55962675367927006 | 0 | False | 0.0010726002783028111 | YES |
| TEST | sensor_13 | 2387.8899999999999 | 2388.3200000000002 | 2388.0710247403836 | 0.05693431032083144 | 0 | False | 2.3841129401509735E-05 | YES |
| TEST | sensor_14 | 8108.5 | 8220.4799999999996 | 8138.9478168906508 | 10.188604979992519 | 0 | False | 0.0012518331864529518 | YES |
| TEST | sensor_15 | 8.3328000000000007 | 8.5413999999999994 | 8.4258439676237913 | 0.029009327545567013 | 0 | False | 0.0034428987359646133 | YES |
| TEST | sensor_16 | 0.029999999999999999 | 0.029999999999999999 | 0.029999999999999999 | 0 | 0 | True | 0 | YES |
| TEST | sensor_17 | 389 | 397 | 392.57162492364012 | 1.2335768256476733 | 0 | False | 0.0031422974747286406 | YES |
| TEST | sensor_18 | 2388 | 2388 | 2388 | 0 | 0 | True | 0 | YES |
| TEST | sensor_19 | 100 | 100 | 100 | 0 | 0 | True | 0 | YES |
| TEST | sensor_20 | 38.310000000000002 | 39.409999999999997 | 38.892501527183946 | 0.14168075530496702 | 0 | False | 0.0036428810115476666 | YES |
| TEST | sensor_21 | 22.935400000000001 | 23.6419 | 23.335742692425228 | 0.084120280155625338 | 0 | False | 0.0036047826402770006 | YES |

Low variance screen is a documented descriptive rule only: sample coefficient of variation below 1% for nonzero means. It is a quality-warning candidate, not proof of a fault. Constant columns are min=max. Negative counts are reported for settings and sensors; without an authoritative expected-range contract, observed negatives are warnings rather than silently rejected values.

## Findings and classification

### TRAIN
- DATA_ERROR: no malformed records or non-finite/non-numeric values detected.
- DATA_ERROR: no duplicate Unit-Cycle keys.
- Full-row duplicates: none.
- Skipped cycle numbers: none observed.
- Starting-cycle consistency: all observed units start at cycle 1.
- EXPECTED_CHARACTERISTIC: Unit observation counts differ; sequence-length variation is reported, not treated as an error.
### TEST
- DATA_ERROR: no malformed records or non-finite/non-numeric values detected.
- DATA_ERROR: no duplicate Unit-Cycle keys.
- Full-row duplicates: none.
- Skipped cycle numbers: none observed.
- Starting-cycle consistency: all observed units start at cycle 1.
- EXPECTED_CHARACTERISTIC: Unit observation counts differ; sequence-length variation is reported, not treated as an error.

## Duplicate locations

### TRAIN full-row duplicates
- None.
### TRAIN duplicate Unit-Cycle keys
- None.
### TEST full-row duplicates
- None.
### TEST duplicate Unit-Cycle keys
- None.