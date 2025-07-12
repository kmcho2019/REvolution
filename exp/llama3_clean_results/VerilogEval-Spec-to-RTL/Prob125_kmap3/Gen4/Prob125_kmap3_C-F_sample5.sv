module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care condition
    output out
);

// Direct implementation of the Karnaugh map logic
// 'd' is considered a don't-care, so we optimize the logic without it
assign out = (a) ? 1'b1 : ((c) ? (!b) : 1'b0);

endmodule