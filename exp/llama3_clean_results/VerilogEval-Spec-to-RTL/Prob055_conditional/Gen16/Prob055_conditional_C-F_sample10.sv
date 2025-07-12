module MinFinder(
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

wire [7:0] ab_min;
wire [7:0] cd_min;

MinFinder min_finder_ab(
   .a(a),
   .b(b),
   .min(ab_min)
);

MinFinder min_finder_cd(
   .a(c),
   .b(d),
   .min(cd_min)
);

MinFinder min_finder_final(
   .a(ab_min),
   .b(cd_min),
   .min(min)
);

endmodule