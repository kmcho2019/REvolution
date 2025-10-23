module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;
reg [15:0] result_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    temp = {8'd0, b_reg};
    for (int i = 15; i >= 0; i--) begin
        temp = {temp[14:0], a_reg[15]};
        a_reg = {a_reg[14:0], 1'd0};
        if (temp >= b_reg) begin
            temp = temp - b_reg;
            result_reg = {result_reg[14:0], 1'd1};
        end else begin
            result_reg = {result_reg[14:0], 1'd0};
        end
    end
    result = result_reg;
    odd = temp;
end

endmodule