module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        quotient = 16'b0;
        remainder = a_reg;
    end else begin
        quotient = 0;
        remainder = a_reg;
        for (int i = 15; i >= 0; i--) begin
            if (remainder[15:8] >= b_reg) begin
                quotient = quotient | (1 << i);
                remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0};
            end else begin
                remainder = {remainder[7:0], remainder[15]};
            end
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule