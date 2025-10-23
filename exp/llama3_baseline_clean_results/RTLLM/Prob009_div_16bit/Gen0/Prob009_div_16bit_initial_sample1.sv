module div_16bit(
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (B == 0) begin
        result_reg = 16'b0;
        odd_reg = A;
    end else begin
        reg [15:0] temp;
        reg [15:0] quotient;
        reg [7:0] divisor;
        reg [7:0] dividend_bits;
        reg [7:0] remainder;
        reg [7:0] next_bit;
        integer i;

        temp = A;
        quotient = 16'b0;
        divisor = B;
        remainder = 8'b0;
        next_bit = 8'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            if (i < 8) begin
                next_bit = {8'b0, temp[15-i]};
            end else begin
                next_bit = temp[15-i];
            end

            dividend_bits = {remainder, next_bit};
            if (dividend_bits >= divisor) begin
                remainder = dividend_bits - divisor;
                quotient = {quotient[14:0], 1'b1};
            end else begin
                remainder = dividend_bits;
                quotient = {quotient[14:0], 1'b0};
            end
        end

        result_reg = quotient;
        odd_reg = {8'b0, remainder};
    end
end

assign result = result_reg;
assign odd = odd_reg;

endmodule