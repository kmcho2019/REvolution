module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // First compute all unique pairwise comparisons
    wire a_eq_b = a ~^ b;
    wire a_eq_c = a ~^ c;
    wire a_eq_d = a ~^ d;
    wire a_eq_e = a ~^ e;
    wire b_eq_c = b ~^ c;
    wire b_eq_d = b ~^ d;
    wire b_eq_e = b ~^ e;
    wire c_eq_d = c ~^ d;
    wire c_eq_e = c ~^ e;
    wire d_eq_e = d ~^ e;

    // Assign outputs using precomputed values where possible
    // a comparisons
    assign out[24] = 1'b1;          // a ~^ a (always true)
    assign out[23] = a_eq_b;
    assign out[22] = a_eq_c;
    assign out[21] = a_eq_d;
    assign out[20] = a_eq_e;
    
    // b comparisons
    assign out[19] = a_eq_b;        // Reuse b ~^ a (same as a ~^ b)
    assign out[18] = 1'b1;          // b ~^ b
    assign out[17] = b_eq_c;
    assign out[16] = b_eq_d;
    assign out[15] = b_eq_e;
    
    // c comparisons
    assign out[14] = a_eq_c;        // Reuse c ~^ a
    assign out[13] = b_eq_c;        // Reuse c ~^ b
    assign out[12] = 1'b1;          // c ~^ c
    assign out[11] = c_eq_d;
    assign out[10] = c_eq_e;
    
    // d comparisons
    assign out[9]  = a_eq_d;        // Reuse d ~^ a
    assign out[8]  = b_eq_d;        // Reuse d ~^ b
    assign out[7]  = c_eq_d;        // Reuse d ~^ c
    assign out[6]  = 1'b1;          // d ~^ d
    assign out[5]  = d_eq_e;
    
    // e comparisons
    assign out[4]  = a_eq_e;        // Reuse e ~^ a
    assign out[3]  = b_eq_e;        // Reuse e ~^ b
    assign out[2]  = c_eq_e;        // Reuse e ~^ c
    assign out[1]  = d_eq_e;        // Reuse e ~^ d
    assign out[0]  = 1'b1;          // e ~^ e

endmodule