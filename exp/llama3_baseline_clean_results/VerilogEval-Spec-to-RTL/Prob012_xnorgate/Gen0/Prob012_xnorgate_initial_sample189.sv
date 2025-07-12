module TopModule(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b);  // Using XOR and inverting the result
// Alternatively, you could directly implement the logic:
// assign out = (a && b) || (!a && !b);

endmodule