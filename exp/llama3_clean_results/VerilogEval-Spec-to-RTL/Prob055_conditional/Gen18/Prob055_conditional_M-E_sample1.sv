module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [7:0] ab_min, ab_max;
wire [7:0] cd_min, cd_max;
wire [7:0] abcd_min, abcd_max;

// First stage of sorting network
assign ab_min = (a < b)? a : b;
assign ab_max = (a < b)? b : a;

assign cd_min = (c < d)? c : d;
assign cd_max = (c < d)? d : c;

// Second stage of sorting network
assign abcd_min = (ab_min < cd_min)? ab_min : cd_min;
assign abcd_max = (ab_min < cd_min)? cd_max : ab_min;

// Output the minimum value
assign min = abcd_min;

endmodule