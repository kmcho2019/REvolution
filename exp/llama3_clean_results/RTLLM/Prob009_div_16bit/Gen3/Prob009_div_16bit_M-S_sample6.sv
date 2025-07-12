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
        if (i >= 8 && odd[15:8] >= b_reg) begin
            result[15-i] = 1;
            odd = (odd[15:8] - b_reg) << 8 | odd[7:0];
        end else if (i < 8 && odd[7:0] >= b_reg) begin
            result[7-i] = 1;
            odd[7:0] = odd[7:0] - b_reg;
        end else begin
            odd = (i >= 8) ? (odd << 1) : odd;
        end
    end
end

endmodule