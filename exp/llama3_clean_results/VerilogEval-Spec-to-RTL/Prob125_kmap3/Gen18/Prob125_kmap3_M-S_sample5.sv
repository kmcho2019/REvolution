module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);
assign out = a | (~a & ~b & c);
endmodule