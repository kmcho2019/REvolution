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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] remainder_reg;
reg [7:0] quotient_reg;
reg [2:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            remainder_reg <= {8'b0, dividend_reg};
            quotient_reg <= 8'b0;
            start_cnt <= 1;
            cnt <= 0;
            res_valid <= 0;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                start_cnt <= 0;
                result <= {remainder_reg[15:8], quotient_reg};
                res_valid <= 1;
            end else begin
                if (remainder_reg[15:8] >= divisor_reg) begin
                    remainder_reg <= {remainder_reg[15:8] - divisor_reg, 1'b1, remainder_reg[7:1]};
                    quotient_reg <= {quotient_reg[6:0], 1'b1};
                end else begin
                    remainder_reg <= {remainder_reg[15:8], 1'b0, remainder_reg[7:1]};
                    quotient_reg <= {quotient_reg[6:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule