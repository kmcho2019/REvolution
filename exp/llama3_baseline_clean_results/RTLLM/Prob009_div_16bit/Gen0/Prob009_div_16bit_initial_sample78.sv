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
    reg [15:0] temp_quotient;
    reg [7:0] temp_remainder;
    reg [15:0] temp_dividend;
    reg [7:0] temp_divisor;

    temp_dividend = a_reg;
    temp_divisor = b_reg;
    temp_quotient = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        temp_remainder = {temp_dividend[15], temp_remainder[7:0]};
        temp_dividend = {temp_dividend[14:0], 1'b0};

        if (temp_remainder >= temp_divisor) begin
            temp_quotient = {1'b1, temp_quotient[14:0]};
            temp_remainder = temp_remainder - temp_divisor;
        end else begin
            temp_quotient = {1'b0, temp_quotient[14:0]};
        end
    end

    for (int i = 7; i >= 0; i--) begin
        if (temp_dividend >= temp_divisor) begin
            temp_quotient = {1'b1, temp_quotient[14:0]};
            temp_dividend = temp_dividend - temp_divisor;
        end else begin
            temp_quotient = {1'b0, temp_quotient[14:0]};
        end
    end

    result = {8'b0, temp_quotient[7:0]};
    odd = {8'b0, temp_dividend};
end

endmodule