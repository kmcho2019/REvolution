module Comparator(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] min
);

always @(*) begin
    min = (a < b)? a : b;
end

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

reg [7:0] ab_min;
reg [7:0] cd_min;

Comparator comparator_ab(
   .a(a),
   .b(b),
   .min(ab_min)
);

Comparator comparator_cd(
   .a(c),
   .b(d),
   .min(cd_min)
);

Comparator comparator_min(
   .a(ab_min),
   .b(cd_min),
   .min(min)
);

endmodule