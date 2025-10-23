module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x == y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
    
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);
    
    or or1(a1_out, b1_out, or_out);
    and and1(a2_out, b2_out, and_out);
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