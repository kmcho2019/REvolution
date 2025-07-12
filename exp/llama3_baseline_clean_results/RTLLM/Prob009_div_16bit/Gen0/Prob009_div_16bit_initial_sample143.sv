module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] quotient;
    reg [15:0] remainder;
    quotient = 0;
    remainder = a_reg;

    for (int i = 15; i >= 8; i--) begin
        reg [7:0] temp;
        temp = remainder[15:8];
        if (temp >= b_reg) begin
            quotient[15 - i] = 1;
            remainder = (remainder[15:8] - b_reg) << 8 | remainder[7:0];
        end else begin
            quotient[15 - i] = 0;
            remainder = remainder << 8 | remainder[7:0];
        end
        remainder = remainder[15:0];
    end
    result = quotient;
    odd = remainder;
end

endmodule