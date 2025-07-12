module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Considered as don't-care
    output out
);

// Directly implementing the logic with minimal operations
// Considering 'd' as a don't-care
assign out = a? 1'b1 : (c &&!b);

endmodule