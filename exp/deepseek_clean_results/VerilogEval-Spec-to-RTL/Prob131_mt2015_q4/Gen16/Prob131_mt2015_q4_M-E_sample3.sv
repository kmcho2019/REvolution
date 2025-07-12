module TopModule(
    input x,
    input y,
    output z
);
    // Combined logic for Module A and B
    wire a_out = (x ^ y) & x;  // Module A function
    
    // Module B implemented as LUT
    wire b_out = (x & y) | (~x & ~y);  // XNOR function
    
    // Optimized final output using XNOR
    assign z = ~(a_out ^ b_out);
endmodule