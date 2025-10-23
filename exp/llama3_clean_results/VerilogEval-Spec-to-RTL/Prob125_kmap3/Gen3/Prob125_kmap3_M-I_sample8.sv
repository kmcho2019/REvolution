module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Explicitly considering 'd' as a don't-care
assign out = a ? 1'b1 : (c ? ~b : 1'b0);

endmodule