module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x == y); // z is 1 when x and y are the same (both 0 or both 1)
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    A a_inst1(x, y, a1);
    B b_inst1(x, y, b1);
    A a_inst2(x, y, a2);
    B b_inst2(x, y, b2);
    
    or or_gate(a1, b1, or_out);
    and and_gate(a2, b2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule

module or(a, b, z);
    input a, b;
    output z;
    assign z = a | b;
endmodule

module and(a, b, z);
    input a, b;
    output z;
    assign z = a & b;
endmodule

module xor(a, b, z);
    input a, b;
    output z;
    assign z = a ^ b;
endmodule