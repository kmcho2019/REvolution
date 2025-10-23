module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, 
               count8, count9, count10, count11, count12, count13, count14, 
               count15, count16, count17, count18, count19, count20, count21, 
               count22, count23, count24, count25, count26, count27, count28, 
               count29, count30, count31;

    assign count0  = ({5{in[7]}}  + {5{in[6]}} + {5{in[5]}} + {5{in[4]}} + 
                     {5{in[3]}} + {5{in[2]}} + {5{in[1]}} + {5{in[0]}});

    assign count1  = ({5{in[15]}} + {5{in[14]}} + {5{in[13]}} + {5{in[12]}} + 
                     {5{in[11]}} + {5{in[10]}} + {5{in[9]}} + {5{in[8]}});

    assign count2  = ({5{in[23]}} + {5{in[22]}} + {5{in[21]}} + {5{in[20]}} + 
                     {5{in[19]}} + {5{in[18]}} + {5{in[17]}} + {5{in[16]}});

    assign count3  = ({5{in[31]}} + {5{in[30]}} + {5{in[29]}} + {5{in[28]}} + 
                     {5{in[27]}} + {5{in[26]}} + {5{in[25]}} + {5{in[24]}});

    assign count4  = ({5{in[39]}} + {5{in[38]}} + {5{in[37]}} + {5{in[36]}} + 
                     {5{in[35]}} + {5{in[34]}} + {5{in[33]}} + {5{in[32]}});

    assign count5  = ({5{in[47]}} + {5{in[46]}} + {5{in[45]}} + {5{in[44]}} + 
                     {5{in[43]}} + {5{in[42]}} + {5{in[41]}} + {5{in[40]}});

    assign count6  = ({5{in[55]}} + {5{in[54]}} + {5{in[53]}} + {5{in[52]}} + 
                     {5{in[51]}} + {5{in[50]}} + {5{in[49]}} + {5{in[48]}});

    assign count7  = ({5{in[63]}} + {5{in[62]}} + {5{in[61]}} + {5{in[60]}} + 
                     {5{in[59]}} + {5{in[58]}} + {5{in[57]}} + {5{in[56]}});

    assign count8  = ({5{in[71]}} + {5{in[70]}} + {5{in[69]}} + {5{in[68]}} + 
                     {5{in[67]}} + {5{in[66]}} + {5{in[65]}} + {5{in[64]}});

    assign count9  = ({5{in[79]}} + {5{in[78]}} + {5{in[77]}} + {5{in[76]}} + 
                     {5{in[75]}} + {5{in[74]}} + {5{in[73]}} + {5{in[72]}});

    assign count10 = ({5{in[87]}} + {5{in[86]}} + {5{in[85]}} + {5{in[84]}} + 
                     {5{in[83]}} + {5{in[82]}} + {5{in[81]}} + {5{in[80]}});

    assign count11 = ({5{in[95]}} + {5{in[94]}} + {5{in[93]}} + {5{in[92]}} + 
                     {5{in[91]}} + {5{in[90]}} + {5{in[89]}} + {5{in[88]}});

    assign count12 = ({5{in[103]}} + {5{in[102]}} + {5{in[101]}} + {5{in[100]}} + 
                     {5{in[99]}} + {5{in[98]}} + {5{in[97]}} + {5{in[96]}});

    assign count13 = ({5{in[111]}} + {5{in[110]}} + {5{in[109]}} + {5{in[108]}} + 
                     {5{in[107]}} + {5{in[106]}} + {5{in[105]}} + {5{in[104]}});

    assign count14 = ({5{in[119]}} + {5{in[118]}} + {5{in[117]}} + {5{in[116]}} + 
                     {5{in[115]}} + {5{in[114]}} + {5{in[113]}} + {5{in[112]}});

    assign count15 = ({5{in[127]}} + {5{in[126]}} + {5{in[125]}} + {5{in[124]}} + 
                     {5{in[123]}} + {5{in[122]}} + {5{in[121]}} + {5{in[120]}});

    assign count16 = ({5{in[135]}} + {5{in[134]}} + {5{in[133]}} + {5{in[132]}} + 
                     {5{in[131]}} + {5{in[130]}} + {5{in[129]}} + {5{in[128]}});

    assign count17 = ({5{in[143]}} + {5{in[142]}} + {5{in[141]}} + {5{in[140]}} + 
                     {5{in[139]}} + {5{in[138]}} + {5{in[137]}} + {5{in[136]}});

    assign count18 = ({5{in[151]}} + {5{in[150]}} + {5{in[149]}} + {5{in[148]}} + 
                     {5{in[147]}} + {5{in[146]}} + {5{in[145]}} + {5{in[144]}});

    assign count19 = ({5{in[159]}} + {5{in[158]}} + {5{in[157]}} + {5{in[156]}} + 
                     {5{in[155]}} + {5{in[154]}} + {5{in[153]}} + {5{in[152]}});

    assign count20 = ({5{in[167]}} + {5{in[166]}} + {5{in[165]}} + {5{in[164]}} + 
                     {5{in[163]}} + {5{in[162]}} + {5{in[161]}} + {5{in[160]}});

    assign count21 = ({5{in[175]}} + {5{in[174]}} + {5{in[173]}} + {5{in[172]}} + 
                     {5{in[171]}} + {5{in[170]}} + {5{in[169]}} + {5{in[168]}});

    assign count22 = ({5{in[183]}} + {5{in[182]}} + {5{in[181]}} + {5{in[180]}} + 
                     {5{in[179]}} + {5{in[178]}} + {5{in[177]}} + {5{in[176]}});

    assign count23 = ({5{in[191]}} + {5{in[190]}} + {5{in[189]}} + {5{in[188]}} + 
                     {5{in[187]}} + {5{in[186]}} + {5{in[185]}} + {5{in[184]}});

    assign count24 = ({5{in[199]}} + {5{in[198]}} + {5{in[197]}} + {5{in[196]}} + 
                     {5{in[195]}} + {5{in[194]}} + {5{in[193]}} + {5{in[192]}});

    assign count25 = ({5{in[207]}} + {5{in[206]}} + {5{in[205]}} + {5{in[204]}} + 
                     {5{in[203]}} + {5{in[202]}} + {5{in[201]}} + {5{in[200]}});

    assign count26 = ({5{in[215]}} + {5{in[214]}} + {5{in[213]}} + {5{in[212]}} + 
                     {5{in[211]}} + {5{in[210]}} + {5{in[209]}} + {5{in[208]}});

    assign count27 = ({5{in[223]}} + {5{in[222]}} + {5{in[221]}} + {5{in[220]}} + 
                     {5{in[219]}} + {5{in[218]}} + {5{in[217]}} + {5{in[216]}});

    assign count28 = ({5{in[231]}} + {5{in[230]}} + {5{in[229]}} + {5{in[228]}} + 
                     {5{in[227]}} + {5{in[226]}} + {5{in[225]}} + {5{in[224]}});

    assign count29 = ({5{in[239]}} + {5{in[238]}} + {5{in[237]}} + {5{in[236]}} + 
                     {5{in[235]}} + {5{in[234]}} + {5{in[233]}} + {5{in[232]}});

    assign count30 = ({5{in[247]}} + {5{in[246]}} + {5{in[245]}} + {5{in[244]}} + 
                     {5{in[243]}} + {5{in[242]}} + {5{in[241]}} + {5{in[240]}});

    assign count31 = ({5{in[254]}} + {5{in[253]}} + {5{in[252]}} + {5{in[251]}} + 
                     {5{in[250]}} + {5{in[249]}} + {5{in[248]}} + {5{in[247]}});

    assign count0  = count0  + count1;
    assign count2  = count2  + count3;
    assign count4  = count4  + count5;
    assign count6  = count6  + count7;
    assign count8  = count8  + count9;
    assign count10 = count10 + count11;
    assign count12 = count12 + count13;
    assign count14 = count14 + count15;
    assign count16 = count16 + count17;
    assign count18 = count18 + count19;
    assign count20 = count20 + count21;
    assign count22 = count22 + count23;
    assign count24 = count24 + count25;
    assign count26 = count26 + count27;
    assign count28 = count28 + count29;
    assign count30 = count30 + count31;

    assign count0  = count0  + count2;
    assign count4  = count4  + count6;
    assign count8  = count8  + count10;
    assign count12 = count12 + count14;
    assign count16 = count16 + count18;
    assign count20 = count20 + count22;
    assign count24 = count24 + count26;
    assign count28 = count28 + count30;

    assign count0  = count0  + count4;
    assign count8  = count8  + count12;
    assign count16 = count16 + count20;
    assign count24 = count24 + count28;

    assign count0  = count0  + count8;
    assign count16 = count16 + count24;

    assign out = count0 + count16;

endmodule