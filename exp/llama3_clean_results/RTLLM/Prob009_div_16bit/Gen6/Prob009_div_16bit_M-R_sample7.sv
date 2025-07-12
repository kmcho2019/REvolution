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
    for (int i = 15; i >= 0; i--) begin
        if (odd[15:8] >= b_reg) begin
            if (i < 8) begin
                result[i] = 1;
            end else begin
                result[i-8] = 1;
            end
            odd = (odd << 1) - {b_reg, 8'b0};
        end else begin
            odd = odd << 1;
        end
    end
    odd = odd[7:0];
end

endmodule