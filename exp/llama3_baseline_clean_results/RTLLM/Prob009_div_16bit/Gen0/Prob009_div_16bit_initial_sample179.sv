module div_16bit (
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
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp;
    reg [7:0] i;

    quotient = 0;
    remainder = a_reg;

    for (i = 8; i > 0; i = i - 1) begin
        temp = remainder[15:8];
        if (temp >= b_reg) begin
            quotient = quotient + (1 << (i - 1));
            remainder = (remainder[15:8] - b_reg) << 8 | remainder[7:0];
        end else begin
            remainder = remainder << 8;
        end
    end

    result = quotient;
    odd = remainder;

end

endmodule