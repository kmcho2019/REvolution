// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b); // Simple XOR and negation for equality check
endmodule

// TopModule utilizing the Comparator module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Instantiate the comparator module for each comparison
    // and directly assign outputs to minimize intermediate variables
    Comparator cmp_a_a(out[24], a, a);
    Comparator cmp_a_b(out[23], a, b);
    Comparator cmp_a_c(out[22], a, c);
    Comparator cmp_a_d(out[21], a, d);
    Comparator cmp_a_e(out[20], a, e);

    Comparator cmp_b_a(out[19], b, a);
    Comparator cmp_b_b(out[18], b, b);
    Comparator cmp_b_c(out[17], b, c);
    Comparator cmp_b_d(out[16], b, d);
    Comparator cmp_b_e(out[15], b, e);

    Comparator cmp_c_a(out[14], c, a);
    Comparator cmp_c_b(out[13], c, b);
    Comparator cmp_c_c(out[12], c, c);
    Comparator cmp_c_d(out[11], c, d);
    Comparator cmp_c_e(out[10], c, e);

    Comparator cmp_d_a(out[9], d, a);
    Comparator cmp_d_b(out[8], d, b);
    Comparator cmp_d_c(out[7], d, c);
    Comparator cmp_d_d(out[6], d, d);
    Comparator cmp_d_e(out[5], d, e);

    Comparator cmp_e_a(out[4], e, a);
    Comparator cmp_e_b(out[3], e, b);
    Comparator cmp_e_c(out[2], e, c);
    Comparator cmp_e_d(out[1], e, d);
    Comparator cmp_e_e(out[0], e, e);

    // Consideration for further optimization:
    // The synthesis tool's optimization capabilities can further reduce area and power consumption.
endmodule