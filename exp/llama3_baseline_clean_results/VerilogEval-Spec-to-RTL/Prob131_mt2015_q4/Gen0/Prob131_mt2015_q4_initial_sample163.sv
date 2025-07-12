module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // The given simulation waveform can be represented by the following logic
    // z = ~(x ^ y) when x and y are 0, otherwise z = x & y
    assign z = ~(x ^ y) & ~(x & y) | (x & y);
endmodule

module TopLevel(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;
    
    ModuleA u1(x, y, a1);
    ModuleB u2(x, y, b1);
    ModuleA u3(x, y, a2);
    ModuleB u4(x, y, b2);
    
    or or_gate(b1, a1, or_out);
    and and_gate(a2, b2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule