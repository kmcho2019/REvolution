module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] sr;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

assign result = temp_result;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        neg_divisor <= 8'd0;
        sr <= 16'd0;
        cnt <= 4'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
    end else begin
        if (opn_valid &&!res_valid) begin
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            if (sign) begin
                if (dividend[7]) begin
                    dividend_reg <= -dividend;
                end
                if (divisor[7]) begin
                    neg_divisor <= -divisor;
                end else begin
                    neg_divisor <= divisor;
                end
            end else begin
                neg_divisor <= divisor;
            end
            sr <= {1'd0, dividend_reg};
            cnt <= 1'd1;
            start_cnt <= 1'd1;
        end

        if (start_cnt) begin
            if (cnt == 8'd8) begin
                start_cnt <= 1'd0;
                cnt <= 4'd0;
                temp_result <= {sr[15:8], sr[7:0]};
                res_valid <= 1'd1;
            end else begin
                if (sr[15:8] >= neg_divisor) begin
                    sr <= {1'd0, sr[15:8] - neg_divisor, sr[7]};
                end else begin
                    sr <= {1'd1, sr[15:8], sr[7]};
                end
                cnt <= cnt + 1'd1;
            end
        end

        if (rst ||!opn_valid) begin
            res_valid <= 1'd0;
        end
    end
end

endmodule