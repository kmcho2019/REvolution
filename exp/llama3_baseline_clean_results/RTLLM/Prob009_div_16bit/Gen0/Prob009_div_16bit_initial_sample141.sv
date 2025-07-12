module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;
reg [15:0] quotient;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient = 16'd0;
    temp = a_reg;
    for (int i = 15; i >= 0; i--) begin
        if (temp[15:8] >= b_reg) begin
            quotient[15-i] = 1'b1;
            temp = {temp[7:0], 1'b0} - {b_reg, 8'd0};
        end else begin
            temp = {temp[7:0], temp[15]};
        end
    end
    result = quotient;
    odd = temp;
end

endmodule