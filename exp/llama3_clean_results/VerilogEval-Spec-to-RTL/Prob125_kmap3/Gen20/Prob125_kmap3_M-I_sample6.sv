module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care condition, ignored in the logic
    output out
);

// Simplified logical expression based on the observations from the Karnaugh map
assign out = a || (!a &&!b && c);

endmodule