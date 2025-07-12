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

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out;
    
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);
    
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
endmodule