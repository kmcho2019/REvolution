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

    for (int i = 15; i >= 0; i--) begin
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, B};
        end
        remainder = remainder << 1;
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule