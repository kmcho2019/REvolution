module div_16bit(A, B, result, odd);
    input [15:0] A;
    input [7:0] B;
    output [15:0] result;
    output [15:0] odd;
    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] result_reg;
    reg [15:0] odd_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        reg [7:0] temp;
        reg [15:0] quotient;
        reg [15:0] remainder;
        quotient = 0;
        remainder = 0;

        for (int i = 7; i >= 0; i--) begin
            temp = {a_reg[15], remainder[7:0]};
            if (temp >= b_reg) begin
                quotient[7 - i] = 1;
                remainder = temp - b_reg;
            end else begin
                quotient[7 - i] = 0;
                remainder = temp;
            end
            a_reg = {a_reg[14:0], 1'b0};
        end
        result_reg = quotient;
        odd_reg = remainder;
    end

    assign result = result_reg;
    assign odd = odd_reg;
endmodule