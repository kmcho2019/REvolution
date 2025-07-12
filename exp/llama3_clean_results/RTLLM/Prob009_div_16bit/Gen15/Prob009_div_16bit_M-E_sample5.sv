module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [15:0] temp;

always @(*) begin
    quotient = 0;
    remainder = A;
    temp = 1;

    for (int i = 7; i >= 0; i--) begin
        if ((remainder >> i) >= B) begin
            quotient = quotient | (temp << i);
            remainder = remainder - (B << i);
        end
        temp = temp << 1;
    end

    result = quotient;
    odd = remainder;
end

endmodule