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

reg [7:0] neg_divisor;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] sr;
reg [3:0] cnt;
reg start_cnt;

always @(*) begin
    if(rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= (sign) ? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= (sign) ? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        neg_divisor <= (~divisor_reg) + 1;
        sr <= {1'b0, dividend_reg};
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if(cnt == 4'd8) begin
            res_valid <= 1'b1;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            result <= {sr[8:1], sr[0]};
        end else begin
            if(sr[8:1] >= neg_divisor) begin
                sr <= {sr[7:0] - neg_divisor, 1'b1};
            end else begin
                sr <= {sr[7:0], 1'b0};
            end
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule