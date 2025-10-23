module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Comparison results
    wire a_leq_b = (a <= b);
    wire a_leq_c = (a <= c);
    wire a_leq_d = (a <= d);
    wire b_leq_a = (b <= a);
    wire b_leq_c = (b <= c);
    wire b_leq_d = (b <= d);
    wire c_leq_a = (c <= a);
    wire c_leq_b = (c <= b);
    wire c_leq_d = (c <= d);
    wire d_leq_a = (d <= a);
    wire d_leq_b = (d <= b);
    wire d_leq_c = (d <= c);

    // Minimum detection flags
    wire a_is_min = a_leq_b & a_leq_c & a_leq_d;
    wire b_is_min = b_leq_a & b_leq_c & b_leq_d & ~a_is_min;
    wire c_is_min = c_leq_a & c_leq_b & c_leq_d & ~a_is_min & ~b_is_min;
    wire d_is_min = d_leq_a & d_leq_b & d_leq_c & ~a_is_min & ~b_is_min & ~c_is_min;

    // Output selection
    assign min = (a_is_min) ? a :
                (b_is_min) ? b :
                (c_is_min) ? c :
                d;

endmodule