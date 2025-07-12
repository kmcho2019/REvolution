module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is don't-care, it's included for completeness
    output out
);

// Optimized logic directly implementing the Karnaugh map conditions
// with 'd' ignored as it's a don't-care condition
assign out = (a) || ((!a) && (!b) && c);

// To further optimize the PPA metrics, consider using input registers
// or balancing the load on the inputs to maintain high performance
// and minimize unnecessary switching activity.

endmodule