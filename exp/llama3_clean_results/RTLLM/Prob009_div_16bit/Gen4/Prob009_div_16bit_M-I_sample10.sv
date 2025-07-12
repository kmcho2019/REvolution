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
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] temp;

    if (b_reg == 0) begin
        result = 16'd0;
        odd = a_reg;
    end else begin
        dividend = a_reg;
        divisor = b_reg;
        quotient = 0;

        for (int i = 15; i >= 0; i--) begin
            if (i >= 8) begin
                temp = dividend >> i;
                if (temp >= divisor) begin
                    quotient = quotient + (1 << (i-8));
                    dividend = dividend - (divisor << i);
                end
            end else begin
                if (dividend >= divisor) begin
                    quotient = quotient + (1 << i);
                    dividend = dividend - divisor;
                end
            end
        end

        result = quotient;
        odd = dividend;
    end
end

endmodule