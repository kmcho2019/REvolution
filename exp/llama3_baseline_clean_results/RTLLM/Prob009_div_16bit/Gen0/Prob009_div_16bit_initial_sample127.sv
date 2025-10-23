module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd    // 16-bit remainder
);

reg [15:0] a_reg;  // registered dividend
reg [7:0] b_reg;   // registered divisor
reg [15:0] result_reg;  // registered quotient
reg [15:0] odd_reg;     // registered remainder
reg [15:0] temp;        // temporary register for dividend

always @(*) begin
    a_reg = A;  // update registered dividend
    b_reg = B;  // update registered divisor
end

always @(*) begin
    result_reg = 0;  // initialize quotient
    odd_reg = a_reg;  // initialize remainder with dividend
    temp = a_reg;     // initialize temporary register with dividend
    
    for (int i = 15; i >= 8; i--) begin
        if (temp[15:8] >= b_reg) begin  // compare higher bits of dividend with divisor
            result_reg[15 - i + 7] = 1;  // set quotient bit to 1
            temp = {temp[7:0], 1'b0};  // shift dividend bits and concatenate with 0
            temp = temp - {b_reg, 8'b0};  // subtract divisor from dividend
        end else begin
            result_reg[15 - i + 7] = 0;  // set quotient bit to 0
            temp = {temp[7:0], 1'b0};  // shift dividend bits and concatenate with 0
        end
    end
    
    for (int i = 7; i >= 0; i--) begin
        if (temp[15:8] >= b_reg) begin  // compare higher bits of dividend with divisor
            result_reg[7 - i] = 1;  // set quotient bit to 1
            temp = {temp[7:0], 1'b0};  // shift dividend bits and concatenate with 0
            temp = temp - {b_reg, 8'b0};  // subtract divisor from dividend
        end else begin
            result_reg[7 - i] = 0;  // set quotient bit to 0
            temp = {temp[7:0], 1'b0};  // shift dividend bits and concatenate with 0
        end
    end
    
    odd_reg = temp;  // update remainder
    
    result = result_reg;  // assign quotient to output
    odd = odd_reg;       // assign remainder to output
end

endmodule