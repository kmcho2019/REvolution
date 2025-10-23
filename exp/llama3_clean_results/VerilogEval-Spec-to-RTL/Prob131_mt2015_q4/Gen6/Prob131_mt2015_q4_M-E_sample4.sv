module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); 
endmodule

module OR_GATE(a, b, z);
    input a, b;
    output z;
    assign z = a | b;
endmodule

module AND_GATE(a, b, z);
    input a, b;
    output z;
    assign z = a & b;
endmodule

module XOR_GATE(a, b, z);
    input a, b;
    output z;
    assign z = a ^ b;
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    ModuleA u_a1(x, y, a1);
    ModuleA u_a2(x, y, a2);
    ModuleB u_b1(x, y, b1);
    ModuleB u_b2(x, y, b2);
    OR_GATE u_or(a1, b1, or_out);
    AND_GATE u_and(a2, b2, and_out);
    XOR_GATE u_xor(or_out, and_out, z);
endmodule