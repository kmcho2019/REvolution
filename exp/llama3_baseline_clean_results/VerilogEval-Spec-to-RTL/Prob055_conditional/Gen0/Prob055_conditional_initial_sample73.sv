module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Compare a and b, and c and d, to find the minimum of each pair
    wire [7:0] min_ab = (a < b)? a : b;
    wire [7:0] min_cd = (c < d)? c : d;

    // Find the minimum of the two results
    assign min = (min_ab < min_cd)? min_ab : min_cd;

endmodule