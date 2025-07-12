module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp_b;
    reg [7:0] temp_a;

    quotient = 0;
    remainder = a_reg;

    for (int i = 15; i >= 8; i--) begin
        temp_a = remainder[15:8];
        if (temp_a >= b_reg) begin
            quotient = quotient + (1 << (i - 8));
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            remainder = {remainder[7:0], 1'b0};
        end
    end

    for (int i = 7; i >= 0; i--) begin
        if (remainder[15:8] >= b_reg) begin
            quotient = quotient + (1 << i);
            remainder = remainder - {b_reg, 8'b0};
        end
        remainder = {remainder[7:0], remainder[15]};
    end

    result = quotient;
    odd = remainder;
end

endmodule