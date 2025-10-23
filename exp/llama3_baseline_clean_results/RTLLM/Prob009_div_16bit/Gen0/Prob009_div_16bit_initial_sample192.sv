module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;
reg [15:0] temp_reg;
reg [7:0] temp_div;
reg [15:0] temp_quot;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    temp_reg = 16'd0;
    temp_quot = 16'd0;
    temp_div = b_reg;
    odd_reg = a_reg;
    for (int i = 15; i >= 0; i = i - 1) begin
        if (odd_reg[15:8] >= temp_div) begin
            temp_quot[15 - i] = 1'd1;
            odd_reg = {odd_reg[14:0], 1'd0} - {8'd0, temp_div};
        end else begin
            temp_quot[15 - i] = 1'd0;
            odd_reg = {odd_reg[14:0], 1'd0};
        end
    end
    result_reg = temp_quot;
    odd_reg = odd_reg;
    result = result_reg;
    odd = odd_reg;
end

endmodule