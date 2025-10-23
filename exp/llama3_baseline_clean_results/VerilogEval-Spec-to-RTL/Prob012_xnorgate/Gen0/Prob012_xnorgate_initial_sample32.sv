module TopModule(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b); // Using XOR and inverting the result

// Alternatively, you could also use the equality operator
// assign out = (a == b);

// Or implement it using basic logic gates
// assign out = (a & b) | (~a & ~b);

endmodule