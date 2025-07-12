module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 8; i = i - 1) begin
        if (remainder[15:i-8] >= b_reg) begin
            quotient[15-i+8] = 1;
            remainder = {remainder[14:i-8], remainder[i-9:0]} - {b_reg, 8'd0};
        end else begin
            quotient[15-i+8] = 0;
            remainder = {remainder[14:i-8], remainder[i-9:0]};
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule