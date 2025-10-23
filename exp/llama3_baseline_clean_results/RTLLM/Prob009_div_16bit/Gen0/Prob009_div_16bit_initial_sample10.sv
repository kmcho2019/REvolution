module div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
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
    reg [15:0] quotient;
    reg [15:0] remainder;
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 0; i = i - 1) begin
        reg [7:0] tmp;
        if (i < 8) begin
            tmp = {8'b0, remainder[15:8]};
        end else begin
            tmp = remainder[15:8];
        end
        if (tmp >= b_reg) begin
            quotient[15 - i] = 1;
            remainder = {remainder[7:0], 1'b0} - (b_reg << (15 - i));
        end else begin
            quotient[15 - i] = 0;
            remainder = {remainder[7:0], remainder[15]};
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule