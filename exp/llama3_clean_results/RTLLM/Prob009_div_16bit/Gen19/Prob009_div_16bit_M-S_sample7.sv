module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;

    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= B) begin
            quotient = quotient | (1 << i - 8);
            remainder = {remainder[7:0], 8'd0} - {8'd0, B};
        end
        remainder = {remainder[7:0], remainder[15]};
    end

    if (remainder[7:0] >= B) begin
        quotient = quotient | (1 << 0);
        remainder = remainder - {8'd0, B};
    end

    result = {8'd0, quotient};
    odd = {8'd0, remainder[7:0]};
end

endmodule