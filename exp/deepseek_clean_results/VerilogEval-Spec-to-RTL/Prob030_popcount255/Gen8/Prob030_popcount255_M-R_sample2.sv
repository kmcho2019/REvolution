module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 3 bits (85 groups)
    wire [7:0] partial_counts [0:84];
    
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : COUNT_3BITS
            localparam start = i*3;
            wire [2:0] group = (start+2 <= 254) ? in[start +: 3] : 
                               {in[start], in[start+1], 1'b0};  // Handle last partial group
            assign partial_counts[i] = {5'b0, group[0]} + {5'b0, group[1]} + {5'b0, group[2]};
        end
    endgenerate

    // Second level: Sum all partial counts
    wire [7:0] sum = 
        partial_counts[0] + partial_counts[1] + partial_counts[2] + partial_counts[3] +
        partial_counts[4] + partial_counts[5] + partial_counts[6] + partial_counts[7] +
        partial_counts[8] + partial_counts[9] + partial_counts[10] + partial_counts[11] +
        partial_counts[12] + partial_counts[13] + partial_counts[14] + partial_counts[15] +
        partial_counts[16] + partial_counts[17] + partial_counts[18] + partial_counts[19] +
        partial_counts[20] + partial_counts[21] + partial_counts[22] + partial_counts[23] +
        partial_counts[24] + partial_counts[25] + partial_counts[26] + partial_counts[27] +
        partial_counts[28] + partial_counts[29] + partial_counts[30] + partial_counts[31] +
        partial_counts[32] + partial_counts[33] + partial_counts[34] + partial_counts[35] +
        partial_counts[36] + partial_counts[37] + partial_counts[38] + partial_counts[39] +
        partial_counts[40] + partial_counts[41] + partial_counts[42] + partial_counts[43] +
        partial_counts[44] + partial_counts[45] + partial_counts[46] + partial_counts[47] +
        partial_counts[48] + partial_counts[49] + partial_counts[50] + partial_counts[51] +
        partial_counts[52] + partial_counts[53] + partial_counts[54] + partial_counts[55] +
        partial_counts[56] + partial_counts[57] + partial_counts[58] + partial_counts[59] +
        partial_counts[60] + partial_counts[61] + partial_counts[62] + partial_counts[63] +
        partial_counts[64] + partial_counts[65] + partial_counts[66] + partial_counts[67] +
        partial_counts[68] + partial_counts[69] + partial_counts[70] + partial_counts[71] +
        partial_counts[72] + partial_counts[73] + partial_counts[74] + partial_counts[75] +
        partial_counts[76] + partial_counts[77] + partial_counts[78] + partial_counts[79] +
        partial_counts[80] + partial_counts[81] + partial_counts[82] + partial_counts[83] +
        partial_counts[84];

    assign out = sum;

endmodule