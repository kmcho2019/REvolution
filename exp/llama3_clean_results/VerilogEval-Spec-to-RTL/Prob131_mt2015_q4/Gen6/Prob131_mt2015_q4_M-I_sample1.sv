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
    wire a_out, b_out, or_out, and_out;
    
    A a1(x, y, a_out);
    B b1(x, y, b_out);
    
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule