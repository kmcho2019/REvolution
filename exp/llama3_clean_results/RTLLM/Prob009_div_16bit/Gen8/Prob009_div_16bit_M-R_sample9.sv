module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
    temp_quotient = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        if (remainder >= (B << (i - 8))) begin
            temp_quotient = 1 << (i - 8);
            temp_remainder = remainder - (B << (i - 8));
        end else begin
            temp_quotient = 0;
            temp_remainder = remainder;
        end

        quotient = quotient | temp_quotient;
        remainder = temp_remainder;
    end

    for (int i = 7; i >= 0; i--) begin
        remainder = {remainder[7:0], 1'b0};

        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, B};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule