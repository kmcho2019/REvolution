module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    // Based on the simulation waveform, the output z is 1 when (x, y) is (0, 0) or (1, 1)
    // Otherwise, z is 0
    assign z = (x == 0 && y == 0) || (x == 1 && y == 1);
endmodule

module top(x, y, z);
    input x, y;
    output z;
    wire z1, z2;
    
    A u1(x, y, z1);
    B u2(x, y, z2);
    
    // First pair of A and B submodules connected to an OR gate
    or or_gate(z1, z2, z1);
    
    A u3(x, y, z2);
    B u4(x, y, z);
    
    // Second pair of A and B submodules connected to an AND gate
    and and_gate(z2, z, z2);
    
    // Outputs of OR and AND gates connected to an XOR gate
    xor xor_gate(z1, z2, z);
endmodule