module TopModule(
    input [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    // Divide the input into four 25-bit segments
    reg [24:0] seg1, seg1_reg;
    reg [24:0] seg2, seg2_reg;
    reg [24:0] seg3, seg3_reg;
    reg [24:0] seg4, seg4_reg;

    // Pipeline registers
    reg out_and_reg1, out_and_reg2, out_and_reg3;
    reg out_or_reg1, out_or_reg2, out_or_reg3;
    reg out_xor_reg1, out_xor_reg2, out_xor_reg3;

    // Assign input segments
    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    // Pipeline stage 1
    always @(*) begin
        out_and_reg1 = seg1[0] & seg1[1] & seg1[2] & seg1[3] & seg1[4] & seg1[5] & 
                       seg1[6] & seg1[7] & seg1[8] & seg1[9] & seg1[10] & seg1[11] & 
                       seg1[12] & seg1[13] & seg1[14] & seg1[15] & seg1[16] & seg1[17] & 
                       seg1[18] & seg1[19] & seg1[20] & seg1[21] & seg1[22] & seg1[23] & seg1[24];

        out_or_reg1 = seg1[0] | seg1[1] | seg1[2] | seg1[3] | seg1[4] | seg1[5] | 
                      seg1[6] | seg1[7] | seg1[8] | seg1[9] | seg1[10] | seg1[11] | 
                      seg1[12] | seg1[13] | seg1[14] | seg1[15] | seg1[16] | seg1[17] | 
                      seg1[18] | seg1[19] | seg1[20] | seg1[21] | seg1[22] | seg1[23] | seg1[24];

        out_xor_reg1 = seg1[0] ^ seg1[1] ^ seg1[2] ^ seg1[3] ^ seg1[4] ^ seg1[5] ^ 
                       seg1[6] ^ seg1[7] ^ seg1[8] ^ seg1[9] ^ seg1[10] ^ seg1[11] ^ 
                       seg1[12] ^ seg1[13] ^ seg1[14] ^ seg1[15] ^ seg1[16] ^ seg1[17] ^ 
                       seg1[18] ^ seg1[19] ^ seg1[20] ^ seg1[21] ^ seg1[22] ^ seg1[23] ^ seg1[24];
    end

    // Pipeline stage 2
    always @(*) begin
        out_and_reg2 = out_and_reg1 & (seg2[0] & seg2[1] & seg2[2] & seg2[3] & seg2[4] & seg2[5] & 
                                       seg2[6] & seg2[7] & seg2[8] & seg2[9] & seg2[10] & seg2[11] & 
                                       seg2[12] & seg2[13] & seg2[14] & seg2[15] & seg2[16] & seg2[17] & 
                                       seg2[18] & seg2[19] & seg2[20] & seg2[21] & seg2[22] & seg2[23] & seg2[24]);

        out_or_reg2 = out_or_reg1 | (seg2[0] | seg2[1] | seg2[2] | seg2[3] | seg2[4] | seg2[5] | 
                                     seg2[6] | seg2[7] | seg2[8] | seg2[9] | seg2[10] | seg2[11] | 
                                     seg2[12] | seg2[13] | seg2[14] | seg2[15] | seg2[16] | seg2[17] | 
                                     seg2[18] | seg2[19] | seg2[20] | seg2[21] | seg2[22] | seg2[23] | seg2[24]);

        out_xor_reg2 = out_xor_reg1 ^ (seg2[0] ^ seg2[1] ^ seg2[2] ^ seg2[3] ^ seg2[4] ^ seg2[5] ^ 
                                       seg2[6] ^ seg2[7] ^ seg2[8] ^ seg2[9] ^ seg2[10] ^ seg2[11] ^ 
                                       seg2[12] ^ seg2[13] ^ seg2[14] ^ seg2[15] ^ seg2[16] ^ seg2[17] ^ 
                                       seg2[18] ^ seg2[19] ^ seg2[20] ^ seg2[21] ^ seg2[22] ^ seg2[23] ^ seg2[24]);
    end

    // Pipeline stage 3
    always @(*) begin
        out_and_reg3 = out_and_reg2 & (seg3[0] & seg3[1] & seg3[2] & seg3[3] & seg3[4] & seg3[5] & 
                                       seg3[6] & seg3[7] & seg3[8] & seg3[9] & seg3[10] & seg3[11] & 
                                       seg3[12] & seg3[13] & seg3[14] & seg3[15] & seg3[16] & seg3[17] & 
                                       seg3[18] & seg3[19] & seg3[20] & seg3[21] & seg3[22] & seg3[23] & seg3[24]);

        out_or_reg3 = out_or_reg2 | (seg3[0] | seg3[1] | seg3[2] | seg3[3] | seg3[4] | seg3[5] | 
                                     seg3[6] | seg3[7] | seg3[8] | seg3[9] | seg3[10] | seg3[11] | 
                                     seg3[12] | seg3[13] | seg3[14] | seg3[15] | seg3[16] | seg3[17] | 
                                     seg3[18] | seg3[19] | seg3[20] | seg3[21] | seg3[22] | seg3[23] | seg3[24]);

        out_xor_reg3 = out_xor_reg2 ^ (seg3[0] ^ seg3[1] ^ seg3[2] ^ seg3[3] ^ seg3[4] ^ seg3[5] ^ 
                                       seg3[6] ^ seg3[7] ^ seg3[8] ^ seg3[9] ^ seg3[10] ^ seg3[11] ^ 
                                       seg3[12] ^ seg3[13] ^ seg3[14] ^ seg3[15] ^ seg3[16] ^ seg3[17] ^ 
                                       seg3[18] ^ seg3[19] ^ seg3[20] ^ seg3[21] ^ seg3[22] ^ seg3[23] ^ seg3[24]);
    end

    // Pipeline stage 4
    always @(*) begin
        out_and = out_and_reg3 & (seg4[0] & seg4[1] & seg4[2] & seg4[3] & seg4[4] & seg4[5] & 
                                  seg4[6] & seg4[7] & seg4[8] & seg4[9] & seg4[10] & seg4[11] & 
                                  seg4[12] & seg4[13] & seg4[14] & seg4[15] & seg4[16] & seg4[17] & 
                                  seg4[18] & seg4[19] & seg4[20] & seg4[21] & seg4[22] & seg4[23] & seg4[24]);

        out_or = out_or_reg3 | (seg4[0] | seg4[1] | seg4[2] | seg4[3] | seg4[4] | seg4[5] | 
                                seg4[6] | seg4[7] | seg4[8] | seg4[9] | seg4[10] | seg4[11] | 
                                seg4[12] | seg4[13] | seg4[14] | seg4[15] | seg4[16] | seg4[17] | 
                                seg4[18] | seg4[19] | seg4[20] | seg4[21] | seg4[22] | seg4[23] | seg4[24]);

        out_xor = out_xor_reg3 ^ (seg4[0] ^ seg4[1] ^ seg4[2] ^ seg4[3] ^ seg4[4] ^ seg4[5] ^ 
                                  seg4[6] ^ seg4[7] ^ seg4[8] ^ seg4[9] ^ seg4[10] ^ seg4[11] ^ 
                                  seg4[12] ^ seg4[13] ^ seg4[14] ^ seg4[15] ^ seg4[16] ^ seg4[17] ^ 
                                  seg4[18] ^ seg4[19] ^ seg4[20] ^ seg4[21] ^ seg4[22] ^ seg4[23] ^ seg4[24]);
    end

endmodule