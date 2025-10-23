module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Directly implement the Karnaugh map logic using logical operators
assign out = a | (~a & ~b & c);

endmodule