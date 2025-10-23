module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [7:0] msb_quotient;
reg [7:0] msb_remainder;
reg [7:0] lsb_quotient;
reg [7:0] lsb_remainder;

always @(*) begin
    // Divide the most significant 8 bits of the dividend by the divisor
    if (A[15:8] >= B) begin
        msb_quotient = A[15:8] / B;
        msb_remainder = A[15:8] % B;
    end else begin
        msb_quotient = 0;
        msb_remainder = A[15:8];
    end

    // Concatenate the remainder from the first stage with the least significant 8 bits of the dividend
    reg [15:0] temp = {msb_remainder, A[7:0]};

    // Divide the concatenated result by the divisor
    if (temp[15:8] >= B) begin
        lsb_quotient = temp[15:8] / B;
        lsb_remainder = temp[15:8] % B;
    end else begin
        lsb_quotient = 0;
        lsb_remainder = temp[15:8];
    end

    // Update the result and remainder
    result = {msb_quotient, lsb_quotient};
    odd = {lsb_remainder, temp[7:0]};
end

endmodule