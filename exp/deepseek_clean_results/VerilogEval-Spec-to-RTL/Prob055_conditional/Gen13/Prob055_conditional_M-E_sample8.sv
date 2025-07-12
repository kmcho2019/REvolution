module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // All pairwise comparisons
    wire a_lt_b = (a < b);
    wire a_lt_c = (a < c);
    wire a_lt_d = (a < d);
    wire b_lt_a = ~a_lt_b;
    wire b_lt_c = (b < c);
    wire b_lt_d = (b < d);
    wire c_lt_a = ~a_lt_c;
    wire c_lt_b = ~b_lt_c;
    wire c_lt_d = (c < d);
    wire d_lt_a = ~a_lt_d;
    wire d_lt_b = ~b_lt_d;
    wire d_lt_c = ~c_lt_d;

    // Determine which inputs are minimum candidates
    wire a_is_min = a_lt_b & a_lt_c & a_lt_d;
    wire b_is_min = b_lt_a & b_lt_c & b_lt_d;
    wire c_is_min = c_lt_a & c_lt_b & c_lt_d;
    wire d_is_min = d_lt_a & d_lt_b & d_lt_c;

    // Priority encoder style selection
    assign min = a_is_min ? a :
                b_is_min ? b :
                c_is_min ? c :
                d;

endmodule