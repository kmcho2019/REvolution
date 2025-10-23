module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Original implementation
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
    wire a_out, b_out;
    
    // Single instance of each module type
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Final logic using single computed results
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule