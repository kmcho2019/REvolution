module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy = x ^ y;
    wire a_out = xor_xy & x;       // ModuleA functionality
    wire b_out = ~xor_xy;          // ModuleB functionality
    
    // Simplified output logic: (a|b)^(a&b) == a^b
    assign z = a_out ^ b_out;
endmodule