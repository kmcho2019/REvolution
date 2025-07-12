module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'd0;
        odd = a_reg;
    end else begin
        reg [15:0] temp_quotient;
        reg [15:0] temp_remainder;
        temp_quotient = 16'd0;
        temp_remainder = a_reg;
        for (int i = 15; i >= 0; i--) begin
            reg [7:0] temp_divisor;
            reg [7:0] temp_dividend;
            temp_dividend = temp_remainder[15:8];
            if (temp_dividend >= b_reg) begin
                temp_quotient[15 - i] = 1'b1;
                temp_remainder = (temp_remainder << 1) - (b_reg << 8);
            end else begin
                temp_quotient[15 - i] = 1'b0;
                temp_remainder = temp_remainder << 1;
            end
        end
        result = temp_quotient;
        odd = temp_remainder;
    end
end

endmodule