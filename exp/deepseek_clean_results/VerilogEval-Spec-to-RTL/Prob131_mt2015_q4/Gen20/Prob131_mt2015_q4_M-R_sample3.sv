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
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a1_out, b1_out, a2_out, b2_out;
    
    // First pair of modules
    ModuleA A1(.x(x), .y(y), .z(a1_out));
    ModuleB B1(.x(x), .y(y), .z(b1_out));
    
    // Second pair of modules
    ModuleA A2(.x(x), .y(y), .z(a2_out));
    ModuleB B2(.x(x), .y(y), .z(b2_out));
    
    // Combined output logic - optimized to XOR
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
    
    // Alternative even simpler implementation recognizing the pattern:
    // assign z = a1_out ^ b2_out;
endmodule