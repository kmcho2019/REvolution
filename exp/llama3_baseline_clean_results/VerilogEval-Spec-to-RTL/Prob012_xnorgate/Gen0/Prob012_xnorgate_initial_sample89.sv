module TopModule(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b); // Using XOR and inverting the result

// Alternatively, you could use the equality operator directly
// assign out = (a == b);

endmodule