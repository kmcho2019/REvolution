module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

integer i;
always @(*) begin
    quotient = 0;
    remainder = A;
    for (i = 15; i >= 0; i--) begin
        if (remainder >= (B << (i - 7))) begin
            quotient = quotient | (1 << (i - 7));
            remainder = remainder - (B << (i - 7));
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule