module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x | y);  // NOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    assign z = a_out ^ b_out;
endmodule