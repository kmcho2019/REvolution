module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input, ignored in implementation
    output out
);

// Direct implementation of the Karnaugh map logic using an assign statement
assign out = a || (!a &&!b && c);

endmodule