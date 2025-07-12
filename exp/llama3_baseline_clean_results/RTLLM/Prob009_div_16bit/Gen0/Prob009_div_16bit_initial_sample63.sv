module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp;
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 8; i--) begin
        temp = remainder[15:8];
        if (temp >= b_reg) begin
            quotient[15 - i] = 1;
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            quotient[15 - i] = 0;
            remainder = {remainder[7:0], 1'b0};
        end
    end
    for (int i = 7; i >= 0; i--) begin
        temp = {remainder[15:8], remainder[7]};
        if (temp >= {b_reg, 1'b0}) begin
            quotient[7 - i] = 1;
            remainder = {remainder[6:0], 1'b0} - {b_reg, 1'b0};
        end else begin
            quotient[7 - i] = 0;
            remainder = {remainder[6:0], 1'b0};
        end
    end
    result_reg = quotient;
    odd_reg = remainder;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule