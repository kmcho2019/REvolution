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
    wire a1, b1, a2, b2;
    A a_module1(x, y, a1);
    B b_module1(x, y, b1);
    A a_module2(x, y, a2);
    B b_module2(x, y, b2);
    wire or_output, and_output;
    or or_gate(a1, b1, or_output);
    and and_gate(a2, b2, and_output);
    xor xor_gate(or_output, and_output, z);
endmodule