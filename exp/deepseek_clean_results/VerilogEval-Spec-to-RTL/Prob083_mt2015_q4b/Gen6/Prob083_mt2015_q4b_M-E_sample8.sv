module TopModule (
    input x,
    input y,
    output reg z
);
    // 2-bit address formed by x and y
    // Output is 1 when inputs are equal (00 or 11 cases)
    always @(*) begin
        case ({x, y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
        endcase
    end
endmodule