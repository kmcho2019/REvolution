module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

assign out = (a == 1'b1) ? 1'b1 : ((~b) & c);

endmodule