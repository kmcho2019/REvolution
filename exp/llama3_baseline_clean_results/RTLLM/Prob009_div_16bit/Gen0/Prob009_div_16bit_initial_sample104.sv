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
    reg [15:0] temp;
    reg [15:0] quotient;
    reg [7:0] divisor;
    quotient = 0;
    temp = a_reg;
    divisor = b_reg;
    
    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            temp = {temp[15:1], 1'b0};
        end else begin
            if (temp[15:8] >= divisor) begin
                quotient[15-i] = 1'b1;
                temp[15:8] = temp[15:8] - divisor;
            end else begin
                quotient[15-i] = 1'b0;
            end
            temp = {temp[7:0], temp[15:8]};
        end
    end
    result_reg = quotient;
    odd_reg = temp;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule