module TopModule(
    input  a,
    input  b,
    output out
);
    
    assign out = ~(a ^ b); // Using XOR and NOT operators
    // Alternatively, you can use the following line for the same result
    // assign out = (a == b); // Using equality operator

endmodule