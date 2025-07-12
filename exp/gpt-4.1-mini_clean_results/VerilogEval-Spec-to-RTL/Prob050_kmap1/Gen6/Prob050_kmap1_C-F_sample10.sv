module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Directly compute out = NAND of inverted inputs = ~(~a & ~b & ~c)
    assign out = ~((~a) & (~b) & (~c));
endmodule