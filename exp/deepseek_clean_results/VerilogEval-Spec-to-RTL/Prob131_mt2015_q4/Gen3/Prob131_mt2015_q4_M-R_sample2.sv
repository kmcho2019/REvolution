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
    assign z = ~(x ^ y);  // XNOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Instantiate modules
    wire a1_out, a2_out, b1_out, b2_out;
    
    ModuleA a1(.x(x), .y(y), .z(a1_out));
    ModuleB b1(.x(x), .y(y), .z(b1_out));
    ModuleA a2(.x(x), .y(y), .z(a2_out));
    ModuleB b2(.x(x), .y(y), .z(b2_out));
    
    // Intermediate logic
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule