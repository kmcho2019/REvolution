module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Using ternary operator for assign statement
    assign out_assign = (a && b) ? 1'b1 : 1'b0;
    
    // Using always block with bitwise AND
    reg out_always_reg;
    always @(*) begin
        out_always_reg = a & b;
    end
    assign out_alwaysblock = out_always_reg;

endmodule