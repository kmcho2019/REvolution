module submodule_A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module submodule_B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module top_level_module(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
    
    submodule_A a1(x, y, a1_out);
    submodule_B b1(x, y, b1_out);
    submodule_A a2(x, y, a2_out);
    submodule_B b2(x, y, b2_out);
    
    or or_gate(b1_out, a1_out, or_out);
    and and_gate(b2_out, a2_out, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule