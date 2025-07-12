module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Simplified implementation based on the analysis of the Karnaugh map
assign out = a || (b || c);

endmodule