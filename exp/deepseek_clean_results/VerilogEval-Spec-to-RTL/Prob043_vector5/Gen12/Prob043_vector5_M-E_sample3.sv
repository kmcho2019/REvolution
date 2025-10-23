module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // Pairwise comparator module
    module comparator(input x, y, output equal);
        assign equal = ~(x ^ y);  // XNOR operation
    endmodule

    // Generate all 25 pairwise comparisons
    comparator cmp_a_a (.x(a), .y(a), .equal(out[24]));
    comparator cmp_a_b (.x(a), .y(b), .equal(out[23]));
    comparator cmp_a_c (.x(a), .y(c), .equal(out[22]));
    comparator cmp_a_d (.x(a), .y(d), .equal(out[21]));
    comparator cmp_a_e (.x(a), .y(e), .equal(out[20]));

    comparator cmp_b_a (.x(b), .y(a), .equal(out[19]));
    comparator cmp_b_b (.x(b), .y(b), .equal(out[18]));
    comparator cmp_b_c (.x(b), .y(c), .equal(out[17]));
    comparator cmp_b_d (.x(b), .y(d), .equal(out[16]));
    comparator cmp_b_e (.x(b), .y(e), .equal(out[15]));

    comparator cmp_c_a (.x(c), .y(a), .equal(out[14]));
    comparator cmp_c_b (.x(c), .y(b), .equal(out[13]));
    comparator cmp_c_c (.x(c), .y(c), .equal(out[12]));
    comparator cmp_c_d (.x(c), .y(d), .equal(out[11]));
    comparator cmp_c_e (.x(c), .y(e), .equal(out[10]));

    comparator cmp_d_a (.x(d), .y(a), .equal(out[9]));
    comparator cmp_d_b (.x(d), .y(b), .equal(out[8]));
    comparator cmp_d_c (.x(d), .y(c), .equal(out[7]));
    comparator cmp_d_d (.x(d), .y(d), .equal(out[6]));
    comparator cmp_d_e (.x(d), .y(e), .equal(out[5]));

    comparator cmp_e_a (.x(e), .y(a), .equal(out[4]));
    comparator cmp_e_b (.x(e), .y(b), .equal(out[3]));
    comparator cmp_e_c (.x(e), .y(c), .equal(out[2]));
    comparator cmp_e_d (.x(e), .y(d), .equal(out[1]));
    comparator cmp_e_e (.x(e), .y(e), .equal(out[0]));

endmodule