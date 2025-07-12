// Define a small, reusable vector comparator module
module VectorComparator(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Using a temporary wire to store the result of a comparison
    // might reduce switching activity by minimizing the number of
    // operations that directly drive the output.
    wire eq_a_b = (a == b);
    wire eq_a_c = (a == c);
    wire eq_a_d = (a == d);
    wire eq_a_e = (a == e);
    wire eq_b_c = (b == c);
    wire eq_b_d = (b == d);
    wire eq_b_e = (b == e);
    wire eq_c_d = (c == d);
    wire eq_c_e = (c == e);
    wire eq_d_e = (d == e);

    // Assign the comparison results to the output vector
    assign out[24] = (a == a);
    assign out[23] = eq_a_b;
    assign out[22] = eq_a_c;
    assign out[21] = eq_a_d;
    assign out[20] = eq_a_e;
    assign out[19] = eq_a_b; // Since equality is commutative
    assign out[18] = (b == b);
    assign out[17] = eq_b_c;
    assign out[16] = eq_b_d;
    assign out[15] = eq_b_e;
    assign out[14] = eq_a_c; // Using the stored comparison result
    assign out[13] = eq_b_c;
    assign out[12] = (c == c);
    assign out[11] = eq_c_d;
    assign out[10] = eq_c_e;
    assign out[9]  = eq_a_d;
    assign out[8]  = eq_b_d;
    assign out[7]  = eq_c_d;
    assign out[6]  = (d == d);
    assign out[5]  = eq_d_e;
    assign out[4]  = eq_a_e;
    assign out[3]  = eq_b_e;
    assign out[2]  = eq_c_e;
    assign out[1]  = eq_d_e;
    assign out[0]  = (e == e);

endmodule

// TopModule utilizing the VectorComparator module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    VectorComparator cmp(a, b, c, d, e, out);

endmodule