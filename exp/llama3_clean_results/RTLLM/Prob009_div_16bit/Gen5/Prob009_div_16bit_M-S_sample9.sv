module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] a_temp;
    reg [15:0] b_temp;
    reg [15:0] quotient;
    reg [15:0] remainder;

    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 0; i--) begin
        if (remainder[15:8] >= b_reg) begin
            quotient[15-i] = 1;
            remainder = {remainder[15:8] - b_reg, remainder[7:0]} << 1;
        end else begin
            remainder = {remainder[15:8], remainder[7:0]} << 1;
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule