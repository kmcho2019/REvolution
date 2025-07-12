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
reg [7:0] temp;
reg [7:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = 0;
    temp = b_reg;
    quotient = 0;
    remainder = a_reg;

    for (int i = 15; i >= 0; i--) begin
        if (remainder[15:8] >= temp) begin
            quotient[0] = 1;
            remainder = (remainder[15:8] - temp) << 8 | remainder[7:0];
        end else begin
            quotient[0] = 0;
            remainder = remainder[15:8] << 8 | remainder[7:0];
        end
        result_reg = (result_reg << 1) | quotient[0];
        quotient = quotient >> 1;
    end
    odd_reg = remainder;
    result = result_reg;
    odd = odd_reg;
end

endmodule