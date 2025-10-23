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
reg [7:0] temp;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (i = 15; i >= 8; i = i - 1) begin
        temp = remainder[15:8];
        if (temp >= b_reg) begin
            quotient = quotient | (1 << (i - 8));
            remainder = (remainder - (b_reg << (i - 8)));
        end else begin
            remainder = remainder;
        end
        remainder = {remainder[7:0], remainder[15]};
    end
    result = quotient;
    odd = remainder;
end

endmodule