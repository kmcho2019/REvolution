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
    reg [15:0] temp;
    reg [15:0] quotient;
    quotient = 0;
    temp = a_reg;
    for (int i = 15; i >= 8; i--) begin
        if (temp[15:8] >= b_reg) begin
            quotient[i] = 1;
            temp = {temp[15:8] - b_reg, temp[7:0]};
        end else begin
            quotient[i] = 0;
            temp = {temp[15:8], temp[7:0]};
        end
    end
    result = quotient;
    odd = temp;
end

endmodule