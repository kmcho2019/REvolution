module Comparator(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] min,
    output reg [7:0] max
);

always @(*) begin
    min = (a < b)? a : b;
    max = (a < b)? b : a;
end

endmodule

module MinFinder(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

reg [7:0] ab_min;
reg [7:0] ab_max;
reg [7:0] cd_min;
reg [7:0] cd_max;

Comparator comparator_ab(
   .a(a),
   .b(b),
   .min(ab_min),
   .max(ab_max)
);

Comparator comparator_cd(
   .a(c),
   .b(d),
   .min(cd_min),
   .max(cd_max)
);

always @(*) begin
    min = (ab_min < cd_min)? ab_min : cd_min;
end

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

MinFinder min_finder(
   .a(a),
   .b(b),
   .c(c),
   .d(d),
   .min(min)
);

endmodule