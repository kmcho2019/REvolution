module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Optimal implementation
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // XNOR is most efficient implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single instances of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimal final output calculation
    assign z = a_out ^ b_out;
endmodule