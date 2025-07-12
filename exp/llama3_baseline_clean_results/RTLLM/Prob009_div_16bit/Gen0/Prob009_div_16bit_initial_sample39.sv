module div_16bit(
    input  wire [15:0] A,  // 16-bit dividend
    input  wire [7:0]  B,  // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the dividend
reg [7:0]  b_reg;  // register to hold the divisor

always @(*) begin
    a_reg = A;  // update a_reg with the input value A
    b_reg = B;  // update b_reg with the input value B
end

always @(*) begin
    reg [15:0] quotient;  // register to hold the quotient
    reg [15:0] remainder;  // register to hold the remainder
    reg [7:0]  temp;  // temporary register
    reg [15:0] temp_remainder;  // temporary register to hold the remainder
    quotient = 0;  // initialize the quotient to 0
    remainder = a_reg;  // initialize the remainder with the dividend
    for (int i = 15; i >= 8; i--) begin
        temp = remainder[15:8];  // extract the higher 8 bits of the remainder
        if (temp >= b_reg) begin
            quotient[15-i] = 1;  // set the current bit of the quotient to 1
            temp_remainder = {temp[7:0] - b_reg, remainder[7:0]};  // update the remainder
        end else begin
            quotient[15-i] = 0;  // set the current bit of the quotient to 0
            temp_remainder = {temp[7:0], remainder[7:0]};  // update the remainder
        end
        remainder = temp_remainder;  // update the remainder
    end
    result = quotient;  // output the quotient
    odd = remainder;  // output the remainder
end

endmodule