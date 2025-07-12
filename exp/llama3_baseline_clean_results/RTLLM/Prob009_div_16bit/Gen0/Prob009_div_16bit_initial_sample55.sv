module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd   // 16-bit remainder
);

reg [15:0] a_reg;  // register to store dividend
reg [7:0] b_reg;   // register to store divisor
reg [15:0] result_reg;  // register to store quotient
reg [15:0] odd_reg;     // register to store remainder

// always block to update input values to registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// always block to perform division operation
always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 15; i >= 0; i--) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[15-i] = 1;
            odd_reg = {odd_reg[7:0], odd_reg[15:8] - b_reg};
        end else begin
            result_reg[15-i] = 0;
            odd_reg = {odd_reg[7:0], odd_reg[15:8]};
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule