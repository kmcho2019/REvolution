module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd      // 16-bit remainder
);

reg [15:0] a_reg;  // register to store the dividend
reg [7:0] b_reg;   // register to store the divisor
reg [15:0] temp_result;  // temporary register for the quotient
reg [15:0] temp_odd;     // temporary register for the remainder

// First always block: update the values of the registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform the division operation
always @(*) begin
    temp_result = 0;
    temp_odd = a_reg;
    for (int i = 15; i >= 8; i--) begin
        if (temp_odd[15:8] >= b_reg) begin
            temp_result[15 - i] = 1;
            temp_odd = {temp_odd[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            temp_result[15 - i] = 0;
            temp_odd = {temp_odd[7:0], 1'b0};
        end
    end
    result = temp_result;
    odd = temp_odd;
end

endmodule