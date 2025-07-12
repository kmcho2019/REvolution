module div_16bit(
    input wire [15:0] A,  // 16-bit dividend
    input wire [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the value of A
reg [7:0] b_reg;   // register to hold the value of B
reg [15:0] temp_quotient;  // temporary register to hold the quotient
reg [15:0] temp_remainder;  // temporary register to hold the remainder

always @(*) begin
    a_reg = A;  // update a_reg with the value of A
    b_reg = B;  // update b_reg with the value of B
end

always @(*) begin
    if (b_reg == 0) begin  // check for division by zero
        result = 16'd0;  // set quotient to 0
        odd = a_reg;  // set remainder to the dividend
    end else begin
        temp_quotient = 16'd0;  // initialize temporary quotient
        temp_remainder = a_reg;  // initialize temporary remainder

        for (int i = 15; i >= 0; i = i - 8) begin  // loop through the dividend bits
            reg [7:0] current_bits;  // register to hold the current bits
            if (i < 8) begin  // if there are less than 8 bits left
                current_bits = temp_remainder[7:0];  // extract the remaining bits
            end else begin
                current_bits = temp_remainder[15:8];  // extract the current bits
            end

            if (current_bits > b_reg) begin  // compare the current bits with the divisor
                temp_quotient = temp_quotient << 1;  // shift the quotient left
                temp_quotient[0] = 1'b1;  // set the least significant bit of the quotient
                temp_remainder = (temp_remainder << 1) - b_reg;  // update the remainder
            end else begin
                temp_quotient = temp_quotient << 1;  // shift the quotient left
                temp_quotient[0] = 1'b0;  // set the least significant bit of the quotient
                temp_remainder = temp_remainder << 1;  // shift the remainder left
            end
        end

        result = temp_quotient;  // assign the quotient
        odd = temp_remainder;  // assign the remainder
    end
end

endmodule