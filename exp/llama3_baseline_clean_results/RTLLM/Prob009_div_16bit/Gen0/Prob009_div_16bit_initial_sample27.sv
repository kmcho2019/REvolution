module div_16bit(A, B, result, odd);
    input [15:0] A;
    input [7:0] B;
    output [15:0] result;
    output [15:0] odd;

    reg [15:0] a_reg;
    reg [7:0] b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    reg [15:0] quotient;
    reg [15:0] remainder;

    always @(*) begin
        quotient = 0;
        remainder = a_reg;
        for (int i = 15; i >= 8; i--) begin
            if (remainder[15:8] >= b_reg) begin
                quotient[15 - i] = 1;
                remainder = {remainder[7:0], remainder[15:8] - b_reg};
            end else begin
                remainder = {remainder[7:0], remainder[15:8]};
            end
        end
        result = quotient;
        odd = remainder;
    end
endmodule