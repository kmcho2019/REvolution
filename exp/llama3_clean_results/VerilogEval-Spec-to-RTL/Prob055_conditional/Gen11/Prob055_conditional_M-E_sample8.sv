module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

reg [7:0] min_reg;

always @(*)
begin
    if (a <= b && a <= c && a <= d)
        min_reg = a;
    else if (b <= a && b <= c && b <= d)
        min_reg = b;
    else if (c <= a && c <= b && c <= d)
        min_reg = c;
    else
        min_reg = d;
end

assign min = min_reg;

endmodule