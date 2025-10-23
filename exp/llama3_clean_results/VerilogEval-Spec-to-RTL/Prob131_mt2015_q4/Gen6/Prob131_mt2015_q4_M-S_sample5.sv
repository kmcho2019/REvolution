module A(x, y, z);
    input x, y;
    output z;
    assign z = (x && !y); // Simplified the expression for z
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x == y); // Comparator circuit
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;
    
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);
    
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out; // Maintains the original functionality
endmodule