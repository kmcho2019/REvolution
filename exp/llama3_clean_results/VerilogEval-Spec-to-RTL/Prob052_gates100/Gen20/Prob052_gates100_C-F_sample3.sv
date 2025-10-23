module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into four 25-bit segments
    wire [24:0] seg1;
    wire [24:0] seg2;
    wire [24:0] seg3;
    wire [24:0] seg4;

    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    // Perform operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;

    // AND Operation
    assign and_seg1 = (seg1[0] & seg1[1] & seg1[2] & seg1[3] & seg1[4] & seg1[5] & 
                        seg1[6] & seg1[7] & seg1[8] & seg1[9] & seg1[10] & seg1[11] & 
                        seg1[12] & seg1[13] & seg1[14] & seg1[15] & seg1[16] & seg1[17] & 
                        seg1[18] & seg1[19] & seg1[20] & seg1[21] & seg1[22] & seg1[23] & seg1[24]);
    assign and_seg2 = (seg2[0] & seg2[1] & seg2[2] & seg2[3] & seg2[4] & seg2[5] & 
                        seg2[6] & seg2[7] & seg2[8] & seg2[9] & seg2[10] & seg2[11] & 
                        seg2[12] & seg2[13] & seg2[14] & seg2[15] & seg2[16] & seg2[17] & 
                        seg2[18] & seg2[19] & seg2[20] & seg2[21] & seg2[22] & seg2[23] & seg2[24]);
    assign and_seg3 = (seg3[0] & seg3[1] & seg3[2] & seg3[3] & seg3[4] & seg3[5] & 
                        seg3[6] & seg3[7] & seg3[8] & seg3[9] & seg3[10] & seg3[11] & 
                        seg3[12] & seg3[13] & seg3[14] & seg3[15] & seg3[16] & seg3[17] & 
                        seg3[18] & seg3[19] & seg3[20] & seg3[21] & seg3[22] & seg3[23] & seg3[24]);
    assign and_seg4 = (seg4[0] & seg4[1] & seg4[2] & seg4[3] & seg4[4] & seg4[5] & 
                        seg4[6] & seg4[7] & seg4[8] & seg4[9] & seg4[10] & seg4[11] & 
                        seg4[12] & seg4[13] & seg4[14] & seg4[15] & seg4[16] & seg4[17] & 
                        seg4[18] & seg4[19] & seg4[20] & seg4[21] & seg4[22] & seg4[23] & seg4[24]);

    // OR Operation
    assign or_seg1 = (seg1[0] | seg1[1] | seg1[2] | seg1[3] | seg1[4] | seg1[5] | 
                      seg1[6] | seg1[7] | seg1[8] | seg1[9] | seg1[10] | seg1[11] | 
                      seg1[12] | seg1[13] | seg1[14] | seg1[15] | seg1[16] | seg1[17] | 
                      seg1[18] | seg1[19] | seg1[20] | seg1[21] | seg1[22] | seg1[23] | seg1[24]);
    assign or_seg2 = (seg2[0] | seg2[1] | seg2[2] | seg2[3] | seg2[4] | seg2[5] | 
                      seg2[6] | seg2[7] | seg2[8] | seg2[9] | seg2[10] | seg2[11] | 
                      seg2[12] | seg2[13] | seg2[14] | seg2[15] | seg2[16] | seg2[17] | 
                      seg2[18] | seg2[19] | seg2[20] | seg2[21] | seg2[22] | seg2[23] | seg2[24]);
    assign or_seg3 = (seg3[0] | seg3[1] | seg3[2] | seg3[3] | seg3[4] | seg3[5] | 
                      seg3[6] | seg3[7] | seg3[8] | seg3[9] | seg3[10] | seg3[11] | 
                      seg3[12] | seg3[13] | seg3[14] | seg3[15] | seg3[16] | seg3[17] | 
                      seg3[18] | seg3[19] | seg3[20] | seg3[21] | seg3[22] | seg3[23] | seg3[24]);
    assign or_seg4 = (seg4[0] | seg4[1] | seg4[2] | seg4[3] | seg4[4] | seg4[5] | 
                      seg4[6] | seg4[7] | seg4[8] | seg4[9] | seg4[10] | seg4[11] | 
                      seg4[12] | seg4[13] | seg4[14] | seg4[15] | seg4[16] | seg4[17] | 
                      seg4[18] | seg4[19] | seg4[20] | seg4[21] | seg4[22] | seg4[23] | seg4[24]);

    // XOR Operation
    assign xor_seg1 = (seg1[0] ^ seg1[1] ^ seg1[2] ^ seg1[3] ^ seg1[4] ^ seg1[5] ^ 
                       seg1[6] ^ seg1[7] ^ seg1[8] ^ seg1[9] ^ seg1[10] ^ seg1[11] ^ 
                       seg1[12] ^ seg1[13] ^ seg1[14] ^ seg1[15] ^ seg1[16] ^ seg1[17] ^ 
                       seg1[18] ^ seg1[19] ^ seg1[20] ^ seg1[21] ^ seg1[22] ^ seg1[23] ^ seg1[24]);
    assign xor_seg2 = (seg2[0] ^ seg2[1] ^ seg2[2] ^ seg2[3] ^ seg2[4] ^ seg2[5] ^ 
                       seg2[6] ^ seg2[7] ^ seg2[8] ^ seg2[9] ^ seg2[10] ^ seg2[11] ^ 
                       seg2[12] ^ seg2[13] ^ seg2[14] ^ seg2[15] ^ seg2[16] ^ seg2[17] ^ 
                       seg2[18] ^ seg2[19] ^ seg2[20] ^ seg2[21] ^ seg2[22] ^ seg2[23] ^ seg2[24]);
    assign xor_seg3 = (seg3[0] ^ seg3[1] ^ seg3[2] ^ seg3[3] ^ seg3[4] ^ seg3[5] ^ 
                       seg3[6] ^ seg3[7] ^ seg3[8] ^ seg3[9] ^ seg3[10] ^ seg3[11] ^ 
                       seg3[12] ^ seg3[13] ^ seg3[14] ^ seg3[15] ^ seg3[16] ^ seg3[17] ^ 
                       seg3[18] ^ seg3[19] ^ seg3[20] ^ seg3[21] ^ seg3[22] ^ seg3[23] ^ seg3[24]);
    assign xor_seg4 = (seg4[0] ^ seg4[1] ^ seg4[2] ^ seg4[3] ^ seg4[4] ^ seg4[5] ^ 
                       seg4[6] ^ seg4[7] ^ seg4[8] ^ seg4[9] ^ seg4[10] ^ seg4[11] ^ 
                       seg4[12] ^ seg4[13] ^ seg4[14] ^ seg4[15] ^ seg4[16] ^ seg4[17] ^ 
                       seg4[18] ^ seg4[19] ^ seg4[20] ^ seg4[21] ^ seg4[22] ^ seg4[23] ^ seg4[24]);

    // Combine the results from each segment
    assign out_and = and_seg1 & and_seg2 & and_seg3 & and_seg4;
    assign out_or = or_seg1 | or_seg2 | or_seg3 | or_seg4;
    assign out_xor = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4;

endmodule