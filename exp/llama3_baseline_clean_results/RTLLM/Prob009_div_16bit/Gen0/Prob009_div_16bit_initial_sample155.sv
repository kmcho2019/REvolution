module div_16bit(
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
    if (b_reg == 0) begin
        result = 16'b0;
        odd = a_reg;
    end else begin
        result = 16'b0;
        odd = a_reg;
        for (int i = 15; i >= 0; i--) begin
            if (odd[15:8] >= b_reg) begin
                result[i] = 1'b1;
                odd = {odd[7:0], odd[15]};
                odd = odd - {b_reg, 8'b0};
            end else begin
                result[i] = 1'b0;
                odd = {odd[7:0], odd[15]};
            end
        end
    end
end

endmodule