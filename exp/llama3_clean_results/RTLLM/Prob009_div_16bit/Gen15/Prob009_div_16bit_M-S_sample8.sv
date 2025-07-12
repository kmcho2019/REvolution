module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [7:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        remainder = {remainder[6:0], A[i]};
        if (remainder >= B) begin
            quotient = quotient | (1 << i);
            remainder = remainder - B;
        end
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule