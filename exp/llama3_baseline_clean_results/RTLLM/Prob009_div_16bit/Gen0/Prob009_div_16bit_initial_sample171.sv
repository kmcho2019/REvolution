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
        reg [7:0] temp_remainder;
        reg [15:0] temp_quotient;
        reg [15:0] temp_dividend;
        temp_quotient = 0;
        temp_dividend = a_reg;

        for (int i = 15; i >= 0; i = i - 8) begin
            temp_remainder = (i < 8) ? temp_dividend[7:0] : {temp_dividend[15:i], 8'd0};
            if (temp_remainder >= b_reg) begin
                temp_quotient = (i < 8) ? {temp_quotient, 1'b1} : {temp_quotient, 8'd0, 1'b1};
                temp_dividend = (i < 8) ? {temp_dividend[6:0], 1'b0} : {temp_remainder - b_reg, temp_dividend[i-1:8]};
            end else begin
                temp_quotient = (i < 8) ? {temp_quotient, 1'b0} : {temp_quotient, 8'd0, 1'b0};
                temp_dividend = (i < 8) ? {temp_dividend[6:0], 1'b0} : {temp_remainder, temp_dividend[i-1:8]};
            end
        end

        result = temp_quotient;
        odd = temp_dividend;
    end
endmodule