module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Compare the first pair (a and b) and the second pair (c and d)
    wire [7:0] min_ab = (a < b) ? a : b;
    wire [7:0] min_cd = (c < d) ? c : d;

    // Compare the results of the two selections
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule