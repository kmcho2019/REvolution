module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Implementation using ternary conditional operator
    assign out_assign = (a && b) ? 1'b1 : 1'b0;

    // Implementation using if-else in always block
    reg out_always_reg;
    always @(*) begin
        if (a && b) 
            out_always_reg = 1'b1;
        else
            out_always_reg = 1'b0;
    end

    assign out_alwaysblock = out_always_reg;

endmodule