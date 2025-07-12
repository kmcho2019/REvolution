module TopModule(
    input x,
    input y,
    output z
);
    // Compute each unique term only once
    wire a1 = (x ^ y) & x;       // ModuleA logic
    wire b1 = ~(x ^ y);          // ModuleB logic (XNOR)
    
    // Final output optimized to XOR of A1 and B1
    assign z = a1 ^ b1;
endmodule