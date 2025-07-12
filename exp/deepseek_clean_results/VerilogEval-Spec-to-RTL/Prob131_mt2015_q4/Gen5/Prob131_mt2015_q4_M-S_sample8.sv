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
    assign z = x & y;
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    
    // Instantiate Module A instances
    ModuleA A1(.x(x), .y(y), .z(a1_out));
    ModuleA A2(.x(x), .y(y), .z(a2_out));
    
    // Instantiate Module B instances
    ModuleB B1(.x(x), .y(y), .z(b1_out));
    ModuleB B2(.x(x), .y(y), .z(b2_out));
    
    // Final output logic
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
endmodule