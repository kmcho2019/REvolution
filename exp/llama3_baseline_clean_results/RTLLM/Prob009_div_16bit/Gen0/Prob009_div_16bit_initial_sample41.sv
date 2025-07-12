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
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp;
    quotient = 0;
    remainder = a_reg;

    for (int i = 15; i >= 8; i--) begin
        temp = remainder[15:8];
        if (temp >= b_reg) begin
            quotient[15 - i + 7] = 1;
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'd0};
        end else begin
            quotient[15 - i + 7] = 0;
            remainder = {remainder[7:0], 1'b0};
        end
    end

    for (int i = 7; i >= 0; i--) begin
        temp = remainder[7:0];
        if (temp >= b_reg) begin
            quotient[7 - i] = 1;
            remainder = remainder - b_reg;
        end else begin
            quotient[7 - i] = 0;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule