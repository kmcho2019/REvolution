module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Parallel comparisons
    wire a_min = (a <= b) & (a <= c) & (a <= d);
    wire b_min = (b <  a) & (b <= c) & (b <= d);
    wire c_min = (c <  a) & (c <  b) & (c <= d);
    wire d_min = (d <  a) & (d <  b) & (d <  c);

    // One-hot mux selection
    assign min = (a_min ? a : 8'b0) |
                (b_min ? b : 8'b0) |
                (c_min ? c : 8'b0) |
                (d_min ? d : 8'b0);

endmodule