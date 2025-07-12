module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg; // register to store the dividend
reg [7:0] b_reg;  // register to store the divisor
reg [15:0] result_reg; // register to store the quotient
reg [15:0] odd_reg;    // register to store the remainder

// always block to update the registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// always block to perform the division operation
always @(*) begin
    reg [15:0] temp; // temporary variable to store the remainder
    reg [7:0] temp_quotient; // temporary variable to store the quotient bits
    reg [15:0] quotient; // register to store the quotient
    reg [15:0] remainder; // register to store the remainder

    quotient = 0; // initialize quotient to 0
    remainder = a_reg; // initialize remainder to dividend

    for (int i = 15; i >= 8; i--) begin
        // extract the higher bits of the remainder, matching the bit width of the divisor
        temp = remainder >> (i - 7);
        // compare these bits with the divisor
        if (temp >= b_reg) begin
            // if the remainder bits are greater, set the quotient bit to 1
            quotient = quotient | (1 << (i - 8));
            // update the remainder
            temp = temp - b_reg;
        end else begin
            // if the remainder bits are not greater, set the quotient bit to 0
            temp = temp;
        end
        // concatenate the remainder with the highest remaining 1-bit of the dividend
        remainder = (temp << (i - 7)) | (remainder & ((1 << (i - 7)) - 1));
    end

    // calculate the final remainder
    if (remainder >= b_reg) begin
        quotient = quotient | (1 << 0);
        remainder = remainder - b_reg;
    end

    result_reg = quotient; // update the quotient register
    odd_reg = remainder;   // update the remainder register
end

assign result = result_reg; // assign the quotient register to the output
assign odd = odd_reg;       // assign the remainder register to the output

endmodule