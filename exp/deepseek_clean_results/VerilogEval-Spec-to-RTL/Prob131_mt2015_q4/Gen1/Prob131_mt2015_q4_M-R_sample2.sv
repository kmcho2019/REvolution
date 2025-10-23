module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~x | y;  // Equivalent to original truth table
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single instances since inputs are identical
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Combined logic - OR and AND of same signals is equivalent to:
    // (a_out | b_out) ^ (a_out & b_out) which simplifies to a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule