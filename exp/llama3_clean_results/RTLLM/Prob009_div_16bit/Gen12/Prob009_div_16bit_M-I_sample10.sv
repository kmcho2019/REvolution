module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;

    for (int i = 15; i >= 8; i--) begin
        // Check if the current bits of the remainder are greater than or equal to the divisor
        if (remainder[15:8] >= B) begin
            // Update the quotient and remainder
            quotient = quotient | (1 << (i - 8));
            remainder = (remainder >> 8) - B;
        end else begin
            // Update the remainder without updating the quotient
            remainder = remainder >> 8;
        end
    end

    // Perform the final subtraction to get the remainder
    if (remainder >= B) begin
        quotient = quotient | (1 << 0);
        remainder = remainder - B;
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule