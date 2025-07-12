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
reg [7:0] neg_divisor;
reg [7:0] sr;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor[7:0];
            neg_divisor <= ~divisor_reg + 1;
            sr <= {1'b0, dividend_reg[7:0]};
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                result <= {sr[7:0], sr[7:0] >> 8};
                res_valid <= 1;
            end else begin
                cnt <= cnt + 1;
                if (sr[7:0] >= divisor_reg) begin
                    sr <= {sr[7:0] - divisor_reg, 1'b1};
                end else begin
                    sr <= {sr[7:0], 1'b0};
                end
                sr <= sr << 1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule