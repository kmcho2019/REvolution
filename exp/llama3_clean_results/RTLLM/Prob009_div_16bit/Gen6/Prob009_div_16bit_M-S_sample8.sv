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

    if (b_reg == 0) begin
        result = 0;
        odd = a_reg;
    end else begin
        dividend = a_reg;
        quotient = 0;

        for (reg [4:0] i = 8; i >= 0; i = i - 1) begin
            if (dividend >= (b_reg << i)) begin
                quotient = quotient + (1 << i);
                dividend = dividend - (b_reg << i);
            end
        end

        result = quotient;
        odd = dividend;
    end
end

endmodule