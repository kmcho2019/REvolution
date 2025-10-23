module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

// First, find the minimum of a and b, and c and d
wire [7:0] min_ab = (a < b) ? a : b;
wire [7:0] min_cd = (c < d) ? c : d;

// Then, find the minimum of the two intermediate results
assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule