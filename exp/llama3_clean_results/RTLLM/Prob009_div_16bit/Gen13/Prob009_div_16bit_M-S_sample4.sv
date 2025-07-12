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

    for (int i = 15; i >= 0; i = i - 1) begin
        if (remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, divisor};
        end
        if (i > 0) begin
            remainder = {remainder[7:0], 1'b0};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule