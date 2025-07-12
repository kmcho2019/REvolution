module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result = 0;
    odd = a_reg;
    for (int i = 15; i >= 8; i--) begin
        if (odd[15:8] >= b_reg) begin
            result[15-i] = 1;
            odd = {odd[7:0], 8'b0} + {16'b0, b_reg};
            odd = odd - {b_reg, 8'b0};
        end else begin
            odd = {1'b0, odd[15:1]};
        end
    end
    for (int i = 7; i >= 0; i--) begin
        if ({odd[15:8], odd[7]} >= {b_reg, 1'b0}) begin
            result[15-i] = 1;
            odd = {odd[14:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            odd = {1'b0, odd[15:1]};
        end
    end
end

endmodule