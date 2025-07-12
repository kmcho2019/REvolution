module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct implementation using assign statement
    assign out_assign = a & b;
    
    // Direct implementation using always block
    reg out_always_reg;
    always @(*) out_always_reg = a & b;
    assign out_alwaysblock = out_always_reg;
endmodule