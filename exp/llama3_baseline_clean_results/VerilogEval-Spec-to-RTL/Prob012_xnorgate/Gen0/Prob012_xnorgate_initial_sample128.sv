module TopModule(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b); // Using XOR and inverting the result
    // Alternatively, you can use the equality operator
    // assign out = (a == b);
endmodule