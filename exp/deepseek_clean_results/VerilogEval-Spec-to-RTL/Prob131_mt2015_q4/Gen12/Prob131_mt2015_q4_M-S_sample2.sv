module TopModule(
    input x,
    input y,
    output z
);
    wire a = x & ~y;      // ModuleA functionality
    wire b = ~(x ^ y);    // ModuleB functionality
    
    assign z = a ^ b;     // Final output
endmodule