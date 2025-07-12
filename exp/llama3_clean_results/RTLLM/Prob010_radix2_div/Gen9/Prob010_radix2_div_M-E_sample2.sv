module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [7:0] quotient_reg;  // registered quotient
reg [7:0] remainder_reg;  // registered remainder
reg [3:0] cnt;  // counter

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
        cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid) begin
        if (sign) begin
            // Signed division
            dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
            divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
        end else begin
            // Unsigned division
            dividend_reg <= dividend;
            divisor_reg <= divisor;
        end
        cnt <= 8;
        quotient_reg <= 0;
        remainder_reg <= dividend_reg;
    end else if (cnt > 0) begin
        if (remainder_reg >= divisor_reg) begin
            remainder_reg <= remainder_reg - divisor_reg;
            quotient_reg <= quotient_reg + (1 << (cnt - 1));
        end
        cnt <= cnt - 1;
        remainder_reg <= remainder_reg << 1;
    end else begin
        result <= {remainder_reg, quotient_reg};
        res_valid <= 1;
    end
end

always @(posedge clk) begin
    if (~res_valid) begin
        result <= 0;
    end
end

endmodule