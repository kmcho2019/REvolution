module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the value of A
reg [7:0] b_reg;   // register to hold the value of B
reg [15:0] result_reg;  // register to hold the quotient
reg [15:0] odd_reg;  // register to hold the remainder
reg [15:0] temp;  // temporary register to hold the higher bits of the dividend

always @(*) begin
    a_reg = A;  // update a_reg with the value of A
    b_reg = B;  // update b_reg with the value of B
end

always @(*) begin
    result_reg = 16'b0;  // initialize the quotient to 0
    odd_reg = a_reg;  // initialize the remainder with the value of A
    
    for (int i = 15; i >= 8; i = i - 1) begin
        temp = odd_reg[15:8];  // extract the higher bits of the dividend
        if (temp >= b_reg) begin  // compare the higher bits with the divisor
            result_reg[15 - i] = 1'b1;  // update the quotient
            odd_reg = {odd_reg[7:0], 1'b0} - {b_reg, 8'b0};  // update the remainder
        end else begin
            result_reg[15 - i] = 1'b0;  // update the quotient
            odd_reg = {odd_reg[7:0], 1'b0};  // update the remainder
        end
    end
    
    for (int i = 7; i >= 0; i = i - 1) begin
        if (odd_reg[15] == 1'b1) begin  // check if the most significant bit of the remainder is 1
            result_reg[7 - i] = 1'b1;  // update the quotient
            odd_reg = odd_reg - {b_reg, 8'b0};  // update the remainder
        end else begin
            result_reg[7 - i] = 1'b0;  // update the quotient
        end
        odd_reg = {odd_reg[14:0], 1'b0};  // shift the remainder to the right
    end
    
    result = result_reg;  // assign the quotient to the output
    odd = odd_reg;  // assign the remainder to the output
end

endmodule