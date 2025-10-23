module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x == y)? 1'b1 : 1'b0;
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    ModuleA a_mod1(x, y, a1);
    ModuleB b_mod1(x, y, b1);
    ModuleA a_mod2(x, y, a2);
    ModuleB b_mod2(x, y, b2);

    or or_gate(a1, b1, or_out);
    and and_gate(a2, b2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule