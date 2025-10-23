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

reg [15:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient_reg;
reg [7:0] remainder_reg;
reg [2:0] cnt;
reg start_cnt;
reg res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        res_valid_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
        divisor_reg <= 0;
        dividend_reg <= 0;
        start_cnt <= 0;
    end else begin
        if (!res_valid_reg && opn_valid && !res_valid) begin
            res_valid_reg <= 1;
            start_cnt <= 1;
            cnt <= 1;
            divisor_reg <= divisor;
            dividend_reg <= {dividend, 8'b0};
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                res_valid <= 1;
                res_valid_reg <= 0;
                start_cnt <= 0;
                cnt <= 0;
                result <= {remainder_reg, quotient_reg};
            end else begin
                if (dividend_reg[15:8] >= divisor_reg) begin
                    remainder_reg <= dividend_reg[15:8] - divisor_reg;
                    quotient_reg[7 - cnt + 1] <= 1;
                end else begin
                    remainder_reg <= dividend_reg[15:8];
                    quotient_reg[7 - cnt + 1] <= 0;
                end
                dividend_reg <= {remainder_reg, dividend_reg[7:0]};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule