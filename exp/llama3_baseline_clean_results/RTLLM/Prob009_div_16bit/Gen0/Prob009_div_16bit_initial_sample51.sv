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
    reg [15:0] temp;
    reg [7:0] quotient;
    reg [15:0] remainder;
    integer i;

    quotient = 0;
    remainder = 0;

    for(i = 8; i >= 0; i = i - 1) begin
        if(i == 8) begin
            temp = {a_reg[15:8], 8'b0};
        end
        else begin
            temp = {remainder[7:0], a_reg[15 - i]};
        end

        if(temp >= b_reg) begin
            quotient = quotient + (1 << i);
            remainder = temp - b_reg;
        end
        else begin
            remainder = temp;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule