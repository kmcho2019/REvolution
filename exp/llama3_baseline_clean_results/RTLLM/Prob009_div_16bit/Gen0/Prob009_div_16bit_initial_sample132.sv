module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the dividend value
reg [7:0] b_reg;   // register to hold the divisor value
reg [15:0] quotient;  // register to hold the quotient value
reg [15:0] remainder;  // register to hold the remainder value

// Combinational block to update the register values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Combinational block to perform the division operation
always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 8; i = i - 1) begin
        if (remainder[15:8] >= b_reg) begin
            quotient = quotient + (1 << (i - 8));
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            remainder = {remainder[7:0], 1'b0};
        end
    end
    result = quotient;
    odd = remainder[7:0];
end

endmodule