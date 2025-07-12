module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]    dividend,
    input   [7:0]    divisor,
    input           opn_valid,
    output  [15:0]   result,
    output          res_valid
);

reg     [7:0]    dividend_reg;
reg     [7:0]    divisor_reg;
reg     [15:0]   sr; // shift register
reg     [7:0]    neg_divisor;
reg     [3:0]    cnt;
reg             start_cnt;
reg             res_valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'd0;
        res_valid_reg <= 1'd0;
    end else begin
        if (opn_valid && !res_valid_reg) begin
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
            sr <= {1'd0, dividend_reg};
            neg_divisor <= ~divisor_reg + 1'd1;
            cnt <= 4'd1;
            start_cnt <= 1'd1;
        end else if (start_cnt) begin
            if (cnt == 4'd8) begin
                sr <= {sr[7:0], 8'd0};
                cnt <= 4'd0;
                start_cnt <= 1'd0;
            end else begin
                reg [8:0] temp;
                temp <= sr[15:8] - neg_divisor;
                if (temp[8]) begin
                    sr <= {1'd1, sr[14:0]};
                end else begin
                    sr <= {1'd0, sr[14:0]} + {9'd0, temp[7:0]};
                end
                cnt <= cnt + 1'd1;
            end
        end
        if (rst || (cnt == 4'd0 && !start_cnt)) begin
            res_valid_reg <= 1'd0;
        end else if (cnt == 4'd8) begin
            res_valid_reg <= 1'd1;
        end
    end
end

assign result = sr;
assign res_valid = res_valid_reg;

endmodule