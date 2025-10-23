module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Direct bitwise AND implementation
    assign out_assign = a & b;

    // Implementation using case statement
    reg out_always_reg;
    always @(*) begin
        case ({a, b})
            2'b11: out_always_reg = 1'b1;
            default: out_always_reg = 1'b0;
        endcase
    end

    assign out_alwaysblock = out_always_reg;

endmodule