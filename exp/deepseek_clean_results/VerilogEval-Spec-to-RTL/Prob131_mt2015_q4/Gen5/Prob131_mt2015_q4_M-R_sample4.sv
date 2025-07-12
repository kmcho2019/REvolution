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
    // Instantiate all submodules
    wire a1_out, a2_out, b1_out, b2_out;
    
    ModuleA A1(.x(x), .y(y), .z(a1_out));
    ModuleB B1(.x(x), .y(y), .z(b1_out));
    ModuleA A2(.x(x), .y(y), .z(a2_out));
    ModuleB B2(.x(x), .y(y), .z(b2_out));
    
    // Intermediate gates
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule