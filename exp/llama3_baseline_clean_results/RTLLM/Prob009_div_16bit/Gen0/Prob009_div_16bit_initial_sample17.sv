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
reg [15:0] temp;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 15; i >= 0; i--) begin
        temp = {odd_reg[15:8], 8'd0} - b_reg;
        if (temp[7] == 0) begin
            if (temp < 0) begin
                result_reg = {result_reg[14:0], 1'b0};
            end else begin
                result_reg = {result_reg[14:0], 1'b1};
                odd_reg = temp;
            end
        end else begin
            result_reg = {result_reg[14:0], 1'b0};
        end
        odd_reg = {odd_reg[14:0], odd_reg[15]};
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule