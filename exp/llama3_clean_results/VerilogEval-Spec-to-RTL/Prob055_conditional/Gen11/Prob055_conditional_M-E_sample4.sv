module Comparator(
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

wire [7:0] min_ab;
wire [7:0] max_ab;
wire [7:0] min_cd;
wire [7:0] max_cd;
wire [7:0] min_abcd;
wire [7:0] max_abcd;

Comparator comparator_ab(
    .a(a),
    .b(b),
    .min(min_ab),
    .max(max_ab)
);

Comparator comparator_cd(
    .a(c),
    .b(d),
    .min(min_cd),
    .max(max_cd)
);

Comparator comparator_abcd(
    .a(min_ab),
    .b(min_cd),
    .min(min_abcd),
    .max(max_abcd)
);

assign min = min_abcd;

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