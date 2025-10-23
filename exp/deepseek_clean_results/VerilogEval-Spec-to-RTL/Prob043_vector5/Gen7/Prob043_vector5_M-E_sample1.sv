module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // First compute all unique pairwise comparisons (10 total)
    wire a_eq_b, a_eq_c, a_eq_d, a_eq_e;
    wire b_eq_c, b_eq_d, b_eq_e;
    wire c_eq_d, c_eq_e;
    wire d_eq_e;
    
    assign a_eq_b = a ~^ b;
    assign a_eq_c = a ~^ c;
    assign a_eq_d = a ~^ d;
    assign a_eq_e = a ~^ e;
    assign b_eq_c = b ~^ c;
    assign b_eq_d = b ~^ d;
    assign b_eq_e = b ~^ e;
    assign c_eq_d = c ~^ d;
    assign c_eq_e = c ~^ e;
    assign d_eq_e = d ~^ e;

    // Now build the complete 25-bit output using the intermediate results
    // Row 1: a vs all
    assign out[24] = 1'b1;       // a ~^ a
    assign out[23] = a_eq_b;
    assign out[22] = a_eq_c;
    assign out[21] = a_eq_d;
    assign out[20] = a_eq_e;
    
    // Row 2: b vs all
    assign out[19] = a_eq_b;
    assign out[18] = 1'b1;       // b ~^ b
    assign out[17] = b_eq_c;
    assign out[16] = b_eq_d;
    assign out[15] = b_eq_e;
    
    // Row 3: c vs all
    assign out[14] = a_eq_c;
    assign out[13] = b_eq_c;
    assign out[12] = 1'b1;       // c ~^ c
    assign out[11] = c_eq_d;
    assign out[10] = c_eq_e;
    
    // Row 4: d vs all
    assign out[9] = a_eq_d;
    assign out[8] = b_eq_d;
    assign out[7] = c_eq_d;
    assign out[6] = 1'b1;        // d ~^ d
    assign out[5] = d_eq_e;
    
    // Row 5: e vs all
    assign out[4] = a_eq_e;
    assign out[3] = b_eq_e;
    assign out[2] = c_eq_e;
    assign out[1] = d_eq_e;
    assign out[0] = 1'b1;        // e ~^ e

endmodule