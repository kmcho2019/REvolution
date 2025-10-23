module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Define temporary variables to store the minimum values after comparing pairs of input values
    wire [7:0] min_ab, min_cd;

    // Find the minimum of the first pair of numbers
    assign min_ab = (a < b) ? a : b;

    // Find the minimum of the second pair of numbers
    assign min_cd = (c < d) ? c : d;

    // Finally, find the minimum of all four numbers
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule