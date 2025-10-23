module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the required functionality
    wire a, b;
    assign a = x & ~y; // ModuleA functionality
    assign b = ~(x ^ y); // ModuleB functionality
    
    // Combine the outputs using an XOR gate
    assign z = a ^ b;
endmodule