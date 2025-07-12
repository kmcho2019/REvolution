module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 0;
        odd = 0;
    end else begin
        reg [15:0] temp_quotient;
        reg [15:0] temp_remainder;
        reg [7:0] divisor;

        divisor = b_reg;
        temp_quotient = 0;
        temp_remainder = a_reg;

        for (int i = 15; i >= 8; i--) begin
            if (temp_remainder >= (divisor << (i - 8))) begin
                temp_quotient = temp_quotient | (1 << (i - 8));
                temp_remainder = temp_remainder - (divisor << (i - 8));
            end
        end

        for (int i = 7; i >= 0; i--) begin
            if (temp_remainder >= (divisor << (i))) begin
                temp_quotient = temp_quotient | (1 << i);
                temp_remainder = temp_remainder - (divisor << (i));
            end
        end

        result = temp_quotient;
        odd = temp_remainder;
    end
end

endmodule