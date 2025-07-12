module MinComparator(
    input [7:0] a,
    input [7:0] b,
    output [7:0] min
);

assign min = (a < b)? a : b;

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [7:0] min_ab;
wire [7:0] min_cd;

MinComparator comparator_ab(
   .a(a),
   .b(b),
   .min(min_ab)
);

MinComparator comparator_cd(
   .a(c),
   .b(d),
   .min(min_cd)
);

MinComparator final_comparator(
   .a(min_ab),
   .b(min_cd),
   .min(min)
);

endmodule