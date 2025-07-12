module ComparatorSwap(
    input [7:0] a,
    input [7:0] b,
    output [7:0] min,
    output [7:0] max
);

assign min = (a < b) ? a : b;
assign max = (a < b) ? b : a;

endmodule

module SortingNetwork(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [7:0] ab_min;
wire [7:0] ab_max;
wire [7:0] cd_min;
wire [7:0] cd_max;
wire [7:0] abcd_min;
wire [7:0] abcd_max;

ComparatorSwap comparator_ab(
    .a(a),
    .b(b),
    .min(ab_min),
    .max(ab_max)
);

ComparatorSwap comparator_cd(
    .a(c),
    .b(d),
    .min(cd_min),
    .max(cd_max)
);

ComparatorSwap comparator_abcd(
    .a(ab_min),
    .b(cd_min),
    .min(abcd_min),
    .max(abcd_max)
);

assign min = abcd_min;

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

SortingNetwork sorting_network(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .min(min)
);

endmodule