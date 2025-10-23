module MinFinder(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] min
);

always @(*) begin
    min = (a < b) ? a : b;
end

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

reg [7:0] min_ab;
reg [7:0] min_cd;

MinFinder min_finder_ab(
    .a(a),
    .b(b),
    .min(min_ab)
);

MinFinder min_finder_cd(
    .a(c),
    .b(d),
    .min(min_cd)
);

always @(*) begin
    min = (min_ab < min_cd) ? min_ab : min_cd;
end

endmodule