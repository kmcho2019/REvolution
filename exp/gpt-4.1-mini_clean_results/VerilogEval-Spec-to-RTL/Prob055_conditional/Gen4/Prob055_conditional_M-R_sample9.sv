module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Compare a and b directly using ternary operator
    assign min_ab = (a < b) ? a : b;

    // Compare c and d directly using ternary operator
    assign min_cd = (c < d) ? c : d;

    // Compare the intermediate minimums to get final minimum
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule