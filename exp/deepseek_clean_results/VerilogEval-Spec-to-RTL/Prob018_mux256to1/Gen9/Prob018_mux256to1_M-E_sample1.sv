module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Binary search tree implementation
    assign out = 
        sel[7] ? 
            (sel[6] ? 
                (sel[5] ? 
                    (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[255] : in[254]) 
                                    : (sel[0] ? in[253] : in[252])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[251] : in[250]) 
                                    : (sel[0] ? in[249] : in[248]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[247] : in[246]) 
                                    : (sel[0] ? in[245] : in[244])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[243] : in[242]) 
                                    : (sel[0] ? in[241] : in[240])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[239] : in[238]) 
                                    : (sel[0] ? in[237] : in[236])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[235] : in[234]) 
                                    : (sel[0] ? in[233] : in[232]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[231] : in[230]) 
                                    : (sel[0] ? in[229] : in[228])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[227] : in[226]) 
                                    : (sel[0] ? in[225] : in[224])))) 
                : (sel[4] ? 
                    (sel[3] ? 
                        (sel[2] ? 
                            (sel[1] ? 
                                (sel[0] ? in[223] : in[222]) 
                                : (sel[0] ? in[221] : in[220])) 
                            : (sel[1] ? 
                                (sel[0] ? in[219] : in[218]) 
                                : (sel[0] ? in[217] : in[216]))) 
                        : (sel[2] ? 
                            (sel[1] ? 
                                (sel[0] ? in[215] : in[214]) 
                                : (sel[0] ? in[213] : in[212])) 
                            : (sel[1] ? 
                                (sel[0] ? in[211] : in[210]) 
                                : (sel[0] ? in[209] : in[208])))) 
                    : (sel[3] ? 
                        (sel[2] ? 
                            (sel[1] ? 
                                (sel[0] ? in[207] : in[206]) 
                                : (sel[0] ? in[205] : in[204])) 
                            : (sel[1] ? 
                                (sel[0] ? in[203] : in[202]) 
                                : (sel[0] ? in[201] : in[200]))) 
                        : (sel[2] ? 
                            (sel[1] ? 
                                (sel[0] ? in[199] : in[198]) 
                                : (sel[0] ? in[197] : in[196])) 
                            : (sel[1] ? 
                                (sel[0] ? in[195] : in[194]) 
                                : (sel[0] ? in[193] : in[192]))))) 
            : (sel[6] ? 
                (sel[5] ? 
                    (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[191] : in[190]) 
                                    : (sel[0] ? in[189] : in[188])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[187] : in[186]) 
                                    : (sel[0] ? in[185] : in[184]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[183] : in[182]) 
                                    : (sel[0] ? in[181] : in[180])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[179] : in[178]) 
                                    : (sel[0] ? in[177] : in[176])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[175] : in[174]) 
                                    : (sel[0] ? in[173] : in[172])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[171] : in[170]) 
                                    : (sel[0] ? in[169] : in[168]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[167] : in[166]) 
                                    : (sel[0] ? in[165] : in[164])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[163] : in[162]) 
                                    : (sel[0] ? in[161] : in[160])))) 
                    : (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[159] : in[158]) 
                                    : (sel[0] ? in[157] : in[156])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[155] : in[154]) 
                                    : (sel[0] ? in[153] : in[152]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[151] : in[150]) 
                                    : (sel[0] ? in[149] : in[148])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[147] : in[146]) 
                                    : (sel[0] ? in[145] : in[144])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[143] : in[142]) 
                                    : (sel[0] ? in[141] : in[140])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[139] : in[138]) 
                                    : (sel[0] ? in[137] : in[136]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[135] : in[134]) 
                                    : (sel[0] ? in[133] : in[132])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[131] : in[130]) 
                                    : (sel[0] ? in[129] : in[128]))))) 
                : (sel[5] ? 
                    (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[127] : in[126]) 
                                    : (sel[0] ? in[125] : in[124])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[123] : in[122]) 
                                    : (sel[0] ? in[121] : in[120]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[119] : in[118]) 
                                    : (sel[0] ? in[117] : in[116])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[115] : in[114]) 
                                    : (sel[0] ? in[113] : in[112])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[111] : in[110]) 
                                    : (sel[0] ? in[109] : in[108])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[107] : in[106]) 
                                    : (sel[0] ? in[105] : in[104]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[103] : in[102]) 
                                    : (sel[0] ? in[101] : in[100])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[99] : in[98]) 
                                    : (sel[0] ? in[97] : in[96])))) 
                    : (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[95] : in[94]) 
                                    : (sel[0] ? in[93] : in[92])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[91] : in[90]) 
                                    : (sel[0] ? in[89] : in[88]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[87] : in[86]) 
                                    : (sel[0] ? in[85] : in[84])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[83] : in[82]) 
                                    : (sel[0] ? in[81] : in[80])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[79] : in[78]) 
                                    : (sel[0] ? in[77] : in[76])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[75] : in[74]) 
                                    : (sel[0] ? in[73] : in[72]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[71] : in[70]) 
                                    : (sel[0] ? in[69] : in[68])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[67] : in[66]) 
                                    : (sel[0] ? in[65] : in[64]))))) 
                : (sel[5] ? 
                    (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[63] : in[62]) 
                                    : (sel[0] ? in[61] : in[60])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[59] : in[58]) 
                                    : (sel[0] ? in[57] : in[56]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[55] : in[54]) 
                                    : (sel[0] ? in[53] : in[52])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[51] : in[50]) 
                                    : (sel[0] ? in[49] : in[48])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[47] : in[46]) 
                                    : (sel[0] ? in[45] : in[44])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[43] : in[42]) 
                                    : (sel[0] ? in[41] : in[40]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[39] : in[38]) 
                                    : (sel[0] ? in[37] : in[36])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[35] : in[34]) 
                                    : (sel[0] ? in[33] : in[32])))) 
                    : (sel[4] ? 
                        (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[31] : in[30]) 
                                    : (sel[0] ? in[29] : in[28])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[27] : in[26]) 
                                    : (sel[0] ? in[25] : in[24]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[23] : in[22]) 
                                    : (sel[0] ? in[21] : in[20])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[19] : in[18]) 
                                    : (sel[0] ? in[17] : in[16])))) 
                        : (sel[3] ? 
                            (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[15] : in[14]) 
                                    : (sel[0] ? in[13] : in[12])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[11] : in[10]) 
                                    : (sel[0] ? in[9] : in[8]))) 
                            : (sel[2] ? 
                                (sel[1] ? 
                                    (sel[0] ? in[7] : in[6]) 
                                    : (sel[0] ? in[5] : in[4])) 
                                : (sel[1] ? 
                                    (sel[0] ? in[3] : in[2]) 
                                    : (sel[0] ? in[1] : in[0]))))));

endmodule