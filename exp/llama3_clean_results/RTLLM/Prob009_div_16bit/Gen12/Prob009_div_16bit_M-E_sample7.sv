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
    for (int i = 15; i >= 0; i--) begin
        temp = remainder - (B << i);
        if (temp >= 0) begin
            quotient = quotient | (1 << i);
            remainder = temp;
        end
    end
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule