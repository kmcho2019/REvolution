module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Simplified implementation based on the Karnaugh map observation
assign out = b | c;

endmodule