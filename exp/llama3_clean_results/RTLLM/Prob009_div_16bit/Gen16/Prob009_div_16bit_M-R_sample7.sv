module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;

assign divisor = B;

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, divisor};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule