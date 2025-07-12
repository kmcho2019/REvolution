module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]  result
);

reg     [7:0]       dividend_reg;
reg     [7:0]       divisor_reg;
reg     [7:0]       neg_divisor;
reg     [7:0]       sr;
reg     [2:0]       cnt;
reg                   start_cnt;
reg                   res_valid_reg;
reg     [15:0]       result_reg;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        neg_divisor <= 8'd0;
        sr <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid_reg <= 1'd0;
        result_reg <= 16'd0;
    end else begin
        if (opn_valid && ~res_valid_reg) begin
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend} : {8{1'b0}} + dividend;
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor} : {8{1'b0}} + divisor;
            neg_divisor <= ~({8{1'b0}} + {8{1'b1}} - divisor_reg) + 1'b1;
            sr <= {1'b0, dividend_reg};
            cnt <= 1'd1;
            start_cnt <= 1'd1;
        end
        if (start_cnt) begin
            if (cnt == 8'd8) begin
                cnt <= 3'd0;
                start_cnt <= 1'd0;
                result_reg <= {sr[15:8], sr[7:0]};
            end else begin
                cnt <= cnt + 1'd1;
                if (sr[15:8] >= neg_divisor) begin
                    sr <= {sr[14:0], 1'b1} + {8'd0, ~neg_divisor} + 1'b1;
                end else begin
                    sr <= {sr[14:0], 1'b0};
                end
            end
        end
        if (rst || (cnt == 3'd0 && ~start_cnt)) begin
            res_valid_reg <= 1'd0;
        end else if (cnt == 8'd8) begin
            res_valid_reg <= 1'd1;
        end
        result <= result_reg;
    end
end

assign res_valid = res_valid_reg;

endmodule