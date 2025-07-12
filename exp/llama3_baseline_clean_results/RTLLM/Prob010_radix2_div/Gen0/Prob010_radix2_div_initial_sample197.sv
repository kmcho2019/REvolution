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
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] tmp_result;

assign result = tmp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        tmp_result <= 0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sr <= (sign)? ({1'b0, (~dividend + 1)}) : ({1'b0, dividend});
        neg_divisor <= (sign)? ({1'b0, (~divisor + 1)}) : ({1'b0, divisor});
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            tmp_result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
        end else begin
            if (sr[15] == 0) begin
                sr <= {sr[14:0], 0};
            end else begin
                sr <= {sr[14:0], 1};
            end
            if (sr[15:8] >= neg_divisor) begin
                sr[15:8] <= sr[15:8] - neg_divisor;
                sr[7:0] <= sr[7:0] + 1;
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 0;
    end
end

endmodule