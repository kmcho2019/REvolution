module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    reg A_greater_reg, A_equal_reg, A_less_reg;

    always @(*) begin
        case ({A, B})
            // A is greater than B
            16'h0001, 16'h0002, 16'h0003, 16'h0004, 16'h0005, 16'h0006, 16'h0007, 16'h0008, 16'h0009, 16'h000A, 16'h000B, 16'h000C, 16'h000D, 16'h000E, 16'h000F: begin
                A_greater_reg = 1'b1;
                A_equal_reg = 1'b0;
                A_less_reg = 1'b0;
            end
            // A is equal to B
            16'h0000, 16'h0101, 16'h0202, 16'h0303, 16'h0404, 16'h0505, 16'h0606, 16'h0707, 16'h0808, 16'h0909, 16'h0A0A, 16'h0B0B, 16'h0C0C, 16'h0D0D, 16'h0E0E, 16'h0F0F: begin
                A_greater_reg = 1'b0;
                A_equal_reg = 1'b1;
                A_less_reg = 1'b0;
            end
            // A is less than B
            default: begin
                A_greater_reg = 1'b0;
                A_equal_reg = 1'b0;
                A_less_reg = 1'b1;
            end
        endcase
    end

    assign A_greater = A_greater_reg;
    assign A_equal = A_equal_reg;
    assign A_less = A_less_reg;

endmodule