module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg; // register to hold the dividend value
reg [7:0] b_reg;  // register to hold the divisor value
reg [15:0] quotient; // register to hold the quotient
reg [15:0] remainder; // register to hold the remainder

always @(*) begin
    a_reg = A; // update the dividend register value
    b_reg = B; // update the divisor register value
end

always @(*) begin
    quotient = 0; // initialize quotient to 0
    remainder = a_reg; // initialize remainder with the dividend value

    for (int i = 15; i >= 8; i--) begin
        reg [7:0] temp; // temporary register to hold the extracted dividend bits
        temp = remainder[15:8]; // extract the higher bits of the remainder

        if (temp > b_reg) begin // compare the extracted bits with the divisor
            quotient[15-i+8] = 1; // set the quotient bit to 1 if greater
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0}; // calculate the new remainder
        end else begin
            quotient[15-i+8] = 0; // set the quotient bit to 0 if not greater
            remainder = {remainder[7:0], 1'b0}; // shift the remainder to the left
        end
    end

    result = quotient; // assign the final quotient value
    odd = remainder; // assign the final remainder value
end

endmodule