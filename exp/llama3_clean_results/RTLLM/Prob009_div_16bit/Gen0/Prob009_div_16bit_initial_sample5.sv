module div_16bit (
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
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [7:0] dividend;

    temp_quotient = 0;
    temp_remainder = a_reg;

    for (int i = 15; i >= 8; i--) begin
        if (temp_remainder[15:9] >= b_reg) begin
            temp_quotient[15 - i] = 1;
            temp_remainder = {temp_remainder[14:0], 1'b0} - {b_reg, 8'd0};
        end else begin
            temp_quotient[15 - i] = 0;
            temp_remainder = {temp_remainder[14:0], 1'b0};
        end
    end

    for (int i = 7; i >= 0; i--) begin
        if ({temp_remainder[7:0], 8'd0}[15:9] >= b_reg) begin
            temp_quotient[7 - i] = 1;
            temp_remainder = {temp_remainder[7:0], 8'd0} - {b_reg, 8'd0};
        end else begin
            temp_quotient[7 - i] = 0;
            temp_remainder = {temp_remainder[7:0], 8'd0};
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule