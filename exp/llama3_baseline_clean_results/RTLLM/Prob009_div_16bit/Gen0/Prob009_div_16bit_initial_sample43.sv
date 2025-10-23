module div_16bit(
    input wire [15:0] A, // 16-bit dividend
    input wire [7:0] B,  // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] higher_bits;
    reg [7:0] diff;
    reg [15:0] next_remainder;
    reg [15:0] next_quotient;

    temp_a = a_reg;
    temp_b = b_reg;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i = i - 8) begin
        if (i < 8) begin
            higher_bits = remainder[7:0];
            diff = (higher_bits > temp_b) ? (higher_bits - temp_b) : higher_bits;
            quotient = (higher_bits > temp_b) ? (quotient + (1 << (i - 0))) : quotient;
            next_remainder = {remainder[15:8], diff};
            next_quotient = quotient;
        end else begin
            higher_bits = temp_a[i-:8];
            diff = (higher_bits > temp_b) ? (higher_bits - temp_b) : higher_bits;
            quotient = (higher_bits > temp_b) ? (quotient + (1 << (i - 8))) : quotient;
            next_remainder = {temp_a[i-8-:8], diff};
            next_quotient = quotient;
        end
        remainder = next_remainder;
        quotient = next_quotient;
        temp_a = next_remainder;
    end

    result = quotient;
    odd = remainder;
end

endmodule