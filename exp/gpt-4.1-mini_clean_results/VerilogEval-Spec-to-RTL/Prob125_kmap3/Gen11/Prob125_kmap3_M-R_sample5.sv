module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output reg out
);

always @(*) begin
    wire term1 = (~c & a);
    wire term2 = (c & (~b | a));
    out = term1 | term2;
end

endmodule