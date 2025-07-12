module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Continuous assignment implementation
    assign out_assign = a & b;
    
    // Combinational always block implementation
    reg out_always_reg;
    always @(a or b) begin
        out_always_reg = a & b;
    end
    assign out_alwaysblock = out_always_reg;
endmodule