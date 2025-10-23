module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // First, find the minimum between pairs of inputs
    wire [7:0] min_ab;
    assign min_ab = (a < b) ? a : b;

    wire [7:0] min_cd;
    assign min_cd = (c < d) ? c : d;

    // Then, compare these results to find the overall minimum
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule