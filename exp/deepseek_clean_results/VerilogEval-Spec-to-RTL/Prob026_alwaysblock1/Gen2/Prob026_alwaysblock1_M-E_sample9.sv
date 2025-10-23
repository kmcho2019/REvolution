module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implementation using ternary operator in assign
    assign out_assign = (a == 1'b1) ? b : 1'b0;

    // Implementation using case statement in always block
    always @(*) begin
        case ({a, b})
            2'b00: out_alwaysblock = 1'b0;
            2'b01: out_alwaysblock = 1'b0;
            2'b10: out_alwaysblock = 1'b0;
            2'b11: out_alwaysblock = 1'b1;
            default: out_alwaysblock = 1'b0;
        endcase
    end

endmodule