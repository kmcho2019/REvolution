module TopModule(x, y, z);
    input x, y;
    output z;
    wire xor_xy, a_out, b_out, or_out, and_out;
    
    assign xor_xy = x ^ y; // Compute XOR of x and y once
    assign a_out = x & xor_xy; // Compute Module A's output directly
    assign b_out = ~xor_xy; // Compute Module B's output directly
    
    assign or_out = a_out | b_out; // Compute OR of Module A and Module B outputs
    assign and_out = a_out & b_out; // Compute AND of Module A and Module B outputs
    
    assign z = or_out ^ and_out; // Final output logic
endmodule