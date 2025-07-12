module div_16bit(
    input  [15:0] A,  // 16-bit dividend
    input  [7:0]  B,  // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp;
    reg [7:0]  temp_b;
    reg [15:0] quotient;
    reg [15:0] remainder;

    temp = a_reg;
    temp_b = b_reg;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        if (temp[15:8] >= temp_b) begin
            quotient = quotient | (1 << (i-8));
            remainder = temp[15:8] - temp_b;
        end else begin
            remainder = temp[15:8];
        end

        temp = {remainder, temp[7:0]};
    end

    result = quotient;
    odd = temp;
end

endmodule