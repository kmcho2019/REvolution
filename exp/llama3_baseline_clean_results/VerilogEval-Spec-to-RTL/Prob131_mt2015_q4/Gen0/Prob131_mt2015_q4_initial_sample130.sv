// Module A
module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B
module B(x, y, z);
    input x, y;
    output z;
    assign z = x & y;
endmodule

// Top-level module
module top(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2;
    
    // Instantiate Module A and Module B
    A a_module1(x, y, a1);
    B b_module1(x, y, b1);
    A a_module2(x, y, a2);
    B b_module2(x, y, b2);
    
    // Connect outputs to OR and AND gates
    wire or_out, and_out;
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    
    // Connect OR and AND outputs to XOR gate
    assign z = or_out ^ and_out;
endmodule