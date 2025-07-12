module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;

always @(*) begin
    quotient = 0;
    remainder = A;
    divisor = B;

    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= divisor) begin
            quotient[15-i+8] = 1;
            remainder[15:8] = remainder[15:8] - divisor;
        end
        remainder = {remainder[14:0], A[i]};
    end

    for (int i = 7; i >= 0; i--) begin
        if (remainder[15:8] >= divisor) begin
            quotient[i] = 1;
            remainder[15:8] = remainder[15:8] - divisor;
        end
        remainder = {remainder[14:0], 1'b0};
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule