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
    remainder = A[15:8];

    // Bit position 15
    if (remainder >= B) begin
        quotient[15] = 1;
        remainder -= B;
    end

    // Bit position 14
    remainder = {remainder[7:0], A[7]};
    if (remainder >= {8'd0, B}) begin
        quotient[14] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 13
    remainder = {remainder[7:0], A[6]};
    if (remainder >= {8'd0, B}) begin
        quotient[13] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 12
    remainder = {remainder[7:0], A[5]};
    if (remainder >= {8'd0, B}) begin
        quotient[12] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 11
    remainder = {remainder[7:0], A[4]};
    if (remainder >= {8'd0, B}) begin
        quotient[11] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 10
    remainder = {remainder[7:0], A[3]};
    if (remainder >= {8'd0, B}) begin
        quotient[10] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 9
    remainder = {remainder[7:0], A[2]};
    if (remainder >= {8'd0, B}) begin
        quotient[9] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 8
    remainder = {remainder[7:0], A[1]};
    if (remainder >= {8'd0, B}) begin
        quotient[8] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit position 7
    remainder = {remainder[7:0], A[0]};
    if (remainder >= {8'd0, B}) begin
        quotient[7] = 1;
        remainder = remainder - {8'd0, B};
    end

    // Bit positions 6 to 0
    // Since the divisor is 8 bits, the remainder after the 8th bit will not be further divided.
    quotient[6:0] = 0;

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule