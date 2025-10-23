module div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
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
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [7:0] dividend;

    temp_quotient = 0;
    temp_remainder = 0;

    divisor = b_reg;

    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            temp_remainder = {temp_remainder[14:0], 1'b0};
        end else begin
            temp_remainder = {temp_remainder[14:0], a_reg[i]};
        end

        if (temp_remainder[7:0] >= divisor) begin
            temp_remainder[7:0] = temp_remainder[7:0] - divisor;
            temp_quotient = {temp_quotient[14:0], 1'b1};
        end else begin
            temp_quotient = {temp_quotient[14:0], 1'b0};
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule