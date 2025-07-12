module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

always @(*) begin
    // First level of comparison
    reg [7:0] min_ab;
    if (a < b) min_ab = a;
    else min_ab = b;

    reg [7:0] min_cd;
    if (c < d) min_cd = c;
    else min_cd = d;

    // Second level of comparison
    if (min_ab < min_cd) min = min_ab;
    else min = min_cd;
end

endmodule