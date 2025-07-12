module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is don't-care, it's included for completeness
    output out
);

// The existing implementation is already simple and efficient.
// However, explicitly considering the don't-care condition for 'd' and 
// the optimization for area and power, the logic can be maintained as is.
assign out = (a) || (!a &&!b && c);

endmodule