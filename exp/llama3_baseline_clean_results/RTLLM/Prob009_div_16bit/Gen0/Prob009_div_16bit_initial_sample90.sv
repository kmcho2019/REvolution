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
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] temp_divisor;
    reg [15:0] temp_dividend;
    
    temp_quotient = 0;
    temp_remainder = 0;
    temp_divisor = b_reg;
    temp_dividend = a_reg;
    
    for (int i = 15; i >= 0; i = i - 1) begin
        if (temp_dividend[15:8] >= temp_divisor) begin
            temp_quotient[15 - i] = 1;
            temp_dividend = (temp_dividend[15:8] - temp_divisor) << 8 | temp_dividend[7:0];
        end else begin
            temp_dividend = temp_dividend[15:8] << 8 | temp_dividend[7:0];
        end
    end
    
    result = temp_quotient;
    odd = temp_dividend;
end

endmodule