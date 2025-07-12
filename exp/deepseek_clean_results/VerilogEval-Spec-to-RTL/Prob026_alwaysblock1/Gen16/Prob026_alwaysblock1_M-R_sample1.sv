module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;
    
    // AND gate using always block (direct assignment to output reg)
    reg out_alwaysblock_reg;
    always @(*) begin
        out_alwaysblock_reg = a & b;
    end
    assign out_alwaysblock = out_alwaysblock_reg;
endmodule