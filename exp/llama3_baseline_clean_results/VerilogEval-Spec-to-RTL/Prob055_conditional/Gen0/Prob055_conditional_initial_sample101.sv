module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Find the minimum between a and b, and between c and d
    wire [7:0] min_ab = (a < b) ? a : b;
    wire [7:0] min_cd = (c < d) ? c : d;

    // Then, find the minimum between min_ab and min_cd
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule