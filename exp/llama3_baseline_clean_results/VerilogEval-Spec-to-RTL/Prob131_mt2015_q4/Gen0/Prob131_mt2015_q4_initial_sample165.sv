module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module top(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    A a1_instance(x, y, a1);
    B b1_instance(x, y, b1);
    A a2_instance(x, y, a2);
    B b2_instance(x, y, b2);
    
    or or_instance(a1, b1, or_out);
    and and_instance(a2, b2, and_out);
    xor xor_instance(or_out, and_out, z);
endmodule