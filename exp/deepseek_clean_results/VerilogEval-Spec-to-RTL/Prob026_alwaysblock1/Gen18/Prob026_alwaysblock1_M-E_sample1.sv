module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // LUT implementation using assign with ternary operator
    assign out_assign = ({a,b} == 2'b11) ? 1'b1 : 1'b0;
    
    // LUT implementation using always block with case statement
    reg out_reg;
    always @(*) begin
        case ({a,b})
            2'b00: out_reg = 1'b0;
            2'b01: out_reg = 1'b0;
            2'b10: out_reg = 1'b0;
            2'b11: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end
    assign out_alwaysblock = out_reg;
endmodule