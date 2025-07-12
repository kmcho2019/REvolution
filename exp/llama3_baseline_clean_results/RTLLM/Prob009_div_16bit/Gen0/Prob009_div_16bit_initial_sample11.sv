module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result_reg = 16'd0;
        odd_reg = a_reg;
    end else begin
        reg [15:0] temp_quotient;
        reg [15:0] temp_remainder;
        reg [7:0] temp_divisor;
        temp_quotient = 16'd0;
        temp_remainder = a_reg;
        temp_divisor = b_reg;

        for (int i = 15; i >= 0; i = i - 1) begin
            if (temp_remainder[15:8] >= temp_divisor) begin
                temp_quotient[15 - i] = 1'b1;
                temp_remainder = {temp_remainder[7:0], 8'd0} - temp_divisor;
            end else begin
                temp_quotient[15 - i] = 1'b0;
                temp_remainder = {temp_remainder[7:0], temp_remainder[15]};
            end
        end

        result_reg = temp_quotient;
        odd_reg = temp_remainder;
    end
end

assign result = result_reg;
assign odd = odd_reg;

endmodule