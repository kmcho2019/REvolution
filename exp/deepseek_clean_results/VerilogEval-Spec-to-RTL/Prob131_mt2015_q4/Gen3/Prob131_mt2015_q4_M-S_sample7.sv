module TopModule(
    input x,
    input y,
    output z
);
    wire a_out = (x ^ y) & x;  // ModuleA output
    wire b_out = ~(x ^ y);     // ModuleB output (XNOR)
    
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule