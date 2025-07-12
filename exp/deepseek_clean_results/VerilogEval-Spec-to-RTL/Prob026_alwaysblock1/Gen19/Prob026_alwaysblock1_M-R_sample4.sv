module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct implementation with assign statement
    assign out_assign = a & b;
    
    // Implementation with combinational always block
    reg out_always_reg;
    always @(*) begin
        out_always_reg = a & b;
    end
    assign out_alwaysblock = out_always_reg;
endmodule