module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = x & y;
endmodule

module top(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;
    
    A a1_module(x, y, a1);
    B b1_module(x, y, b1);
    A a2_module(x, y, a2);
    B b2_module(x, y, b2);
    
    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);
    xor xor1(or_out, and_out, z);
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