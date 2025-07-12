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
reg [15:0] temp;  // temporary register
reg [7:0] high_bits;  // register to hold the high bits of the dividend

always @(A or B) begin
    a_reg = A;  // update a_reg with the value of A
    b_reg = B;  // update b_reg with the value of B
end

always @(a_reg or b_reg) begin
    temp = a_reg;  // initialize temp with the value of a_reg
    result_reg = 0;  // initialize result_reg to 0
    odd_reg = 0;  // initialize odd_reg to 0

    for (int i = 15; i >= 8; i--) begin
        high_bits = temp[15:i];  // extract the high bits of the dividend
        if (high_bits >= b_reg) begin
            result_reg = (result_reg << 1) | 1;  // set the quotient to 1
            temp = (temp << 1) - (b_reg << (i - 7));  // update the remainder
        end else begin
            result_reg = result_reg << 1;  // set the quotient to 0
            temp = temp << 1;  // update the remainder
        end
    end

    result_reg = (result_reg << 8) | (temp[7:0] / b_reg);  // update the quotient
    odd_reg = temp[7:0] % b_reg;  // update the remainder

    result = result_reg;  // assign the quotient to the output
    odd = odd_reg;  // assign the remainder to the output
end

endmodule