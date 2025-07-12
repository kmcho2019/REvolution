module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy = x ^ y;
    wire a_out = xor_xy & x;  // Equivalent to ModuleA output
    wire b_out = ~xor_xy;     // Equivalent to ModuleB output
    
    // Simplified output logic: (A|B)^(A&B) == A^B
    assign z = a_out ^ b_out;
endmodule