module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 0; i--) begin
        if (remainder >= (b_reg << (i-7))) begin
            quotient = quotient | (1 << (i-7));
            remainder = remainder - (b_reg << (i-7));
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule