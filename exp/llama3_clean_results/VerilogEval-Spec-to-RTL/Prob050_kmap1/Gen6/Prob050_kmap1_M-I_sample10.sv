module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Simplified expression based on the Karnaugh map's logic
assign out = a | b | c;

endmodule