module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is don't-care, it's included for completeness
    output out
);

// Directly implementing the required logic from the Karnaugh map
// with 'd' being a don't-care condition, thus ignored in the logic
assign out = (a) || (!a &&!b && c);

endmodule