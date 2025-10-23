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
    reg [15:0] temp;
    reg [7:0] remainder;
    reg [15:0] quotient;

    quotient = 0;
    remainder = 0;
    temp = a_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        remainder = {remainder[6:0], temp[15]};
        temp = temp << 1;

        if (remainder >= b_reg) begin
            remainder = remainder - b_reg;
            quotient = {quotient[14:0], 1'b1};
        end else begin
            quotient = {quotient[14:0], 1'b0};
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule