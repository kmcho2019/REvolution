module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;
    
    A a1_module(x, y, a1);
    B b1_module(x, y, b1);
    A a2_module(x, y, a2);
    B b2_module(x, y, b2);
    
    or or_gate(a1, b1, or_out);
    and and_gate(a2, b2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule