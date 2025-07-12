module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    temp = 0;
    for (int i = 15; i >= 0; i = i - 1) begin
        if (i < 8) begin
            if (a_reg[15:8] >= b_reg) begin
                temp[15 - i] = 1;
                a_reg = {a_reg[7:0], 1'b0} - {b_reg, 8'b0};
            end else begin
                temp[15 - i] = 0;
                a_reg = {a_reg[7:0], 1'b0};
            end
        end else begin
            if ({a_reg[15:i], 8'b0} >= {b_reg, 8'b0}) begin
                temp[15 - i] = 1;
                a_reg = {a_reg[15:i - 1], 8'b0} - {b_reg, 8'b0};
            end else begin
                temp[15 - i] = 0;
                a_reg = {a_reg[15:i - 1], 8'b0};
            end
        end
    end
    result = temp;
    odd = a_reg;
end

endmodule