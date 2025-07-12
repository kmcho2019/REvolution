module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
    divisor = B;

    for (int i = 15; i >= 0; i--) begin
        if (remainder[15:8] >= divisor) begin
            quotient[15 - i] = 1'b1;
            remainder[7:0] = remainder[7:0] - divisor;
        end else begin
            quotient[15 - i] = 1'b0;
        end
        if (i > 0) begin
            remainder[15:8] = remainder[7:0];
            remainder[7] = (i > 8) ? A[15 - i] : 1'b0;
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule