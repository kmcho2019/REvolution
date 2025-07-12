module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare 'a' and 'b'
    wire [7:0] min_ab = (a < b) ? a : b;

    // Compare 'c' and 'd'
    wire [7:0] min_cd = (c < d) ? c : d;

    // Compare the minimum of 'a' and 'b' with the minimum of 'c' and 'd'
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule