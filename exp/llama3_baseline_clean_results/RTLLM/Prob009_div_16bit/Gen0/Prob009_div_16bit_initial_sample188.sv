module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;  // registered dividend
reg [7:0] b_reg;   // registered divisor
reg [15:0] result_reg;  // registered quotient
reg [15:0] odd_reg;     // registered remainder

// Always block to register the inputs
always @(*)
begin
    a_reg = A;
    b_reg = B;
end

// Always block to perform the division operation
always @(*)
begin
    reg [15:0] dividend;  // temporary dividend
    reg [7:0] divisor;    // temporary divisor
    reg [15:0] quotient;  // temporary quotient
    reg [15:0] remainder; // temporary remainder
    reg [3:0] i;          // loop counter

    // Initialize the temporary variables
    dividend = a_reg;
    divisor = b_reg;
    quotient = 16'd0;
    remainder = 16'd0;

    // Perform the division operation
    for (i = 8; i >= 0; i = i - 1)
    begin
        // Compare the higher bits of the dividend with the divisor
        if (dividend[15:8] >= divisor)
        begin
            // Set the quotient to 1 and update the remainder
            quotient = quotient << 1;
            quotient[0] = 1'b1;
            remainder = (dividend[15:8] - divisor) << (i - 1);
        end
        else
        begin
            // Set the quotient to 0 and update the remainder
            quotient = quotient << 1;
            remainder = dividend[15:8] << (i - 1);
        end

        // Shift the dividend to process the remaining bits
        dividend = (dividend << 1) | (dividend[7] ? 1'b1 : 1'b0);
    end

    // Assign the final quotient and remainder to the output registers
    result_reg = quotient;
    odd_reg = remainder;
end

// Assign the output registers to the output ports
assign result = result_reg;
assign odd = odd_reg;

endmodule