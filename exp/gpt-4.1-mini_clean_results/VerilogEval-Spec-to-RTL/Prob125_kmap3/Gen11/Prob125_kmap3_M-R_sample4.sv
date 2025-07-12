module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output reg out
);

wire term1, term2, term3;

assign term1 = a & ~c;
assign term2 = c & a;
assign term3 = c & ~b;

always @(*) begin
    out = term1 | term2 | term3;
end

endmodule