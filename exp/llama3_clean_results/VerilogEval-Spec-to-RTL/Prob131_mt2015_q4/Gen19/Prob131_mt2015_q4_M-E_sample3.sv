module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y); // Direct computation of Module A's logic
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Simplified logic for Module B
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire xor_xy, a_out, b1_out, b2_out, or_out, and_out;
    
    assign xor_xy = x ^ y; // Compute XOR of x and y once
    assign a_out = x & xor_xy; // Compute Module A's output
    assign b1_out = ~xor_xy; // Compute Module B's output
    assign b2_out = ~xor_xy; // Compute Module B's output
    
    assign or_out = a_out | b1_out;
    assign and_out = a_out & b2_out;
    assign z = or_out ^ and_out; // Final output logic
endmodule