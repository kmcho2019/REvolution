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

    always @(*) begin
        reg [15:0] temp;
        reg [15:0] quotient;
        reg [7:0] divisor;
        reg [15:0] dividend;
        reg [15:0] remain;

        dividend = a_reg;
        divisor = b_reg;
        quotient = 0;
        remain = 0;

        for (int i = 15; i >= 0; i = i - 1) begin
            temp = {dividend[15:8], remain[7:0]};
            if (temp >= divisor) begin
                quotient = {quotient[14:0], 1'b1};
                remain = temp - divisor;
            end else begin
                quotient = {quotient[14:0], 1'b0};
                remain = temp;
            end
            dividend = {dividend[14:0], 1'b0};
        end

        result = quotient;
        odd = remain;
    end
endmodule