module radix2_div(
    input   clk,
    input   rst,
    input   sign,
    input   [7:0] dividend,
    input   [7:0] divisor,
    input   opn_valid,
    output  res_valid,
    output  [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] sr;  // shift register
reg [7:0] neg_divisor;
reg [3:0] cnt;  // counter
reg start_cnt;
reg res_valid_reg;

assign res_valid = res_valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            dividend_reg <= sign ? {{8{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
            divisor_reg <= sign ? {{8{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
            sr <= (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
            sr <= sr << 1;
            neg_divisor <= (~divisor_reg + 1);
            cnt <= 1;
            start_cnt <= 1'b1;
            res_valid_reg <= 1'b0;
        end else if (start_cnt) begin
            if (cnt == 8'd8) begin
                cnt <= 4'd0;
                start_cnt <= 1'b0;
                res_valid_reg <= 1'b1;
                result <= {sr[15:8], sr[7:0]};
            end else begin
                if (sr[15:8] >= neg_divisor) begin
                    sr <= (sr[15:8] - neg_divisor) << 1 | 1'b1;
                end else begin
                    sr <= sr << 1;
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid && !opn_valid) begin
            res_valid_reg <= 1'b0;
        end
    end
end

endmodule