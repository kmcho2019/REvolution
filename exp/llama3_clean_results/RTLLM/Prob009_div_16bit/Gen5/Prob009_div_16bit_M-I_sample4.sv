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
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [15:0] temp;

    dividend = 0;
    quotient = 0;

    if (b_reg == 0) begin
        result = 0;
        odd = a_reg;
    end else begin
        dividend = a_reg;
        quotient = 0;

        for (reg [4:0] i = 8; i >= 0; i--) begin
            temp = (b_reg << i);
            if (dividend >= temp) begin
                quotient = quotient + (1 << i);
                dividend = dividend - temp;
            end
        end

        result = quotient;
        odd = dividend;
    end
end

endmodule