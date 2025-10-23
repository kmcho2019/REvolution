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
reg start_cnt;
reg [3:0] cnt;
reg res_valid_reg;
reg [15:0] result_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid_reg <= 0;
        start_cnt <= 0;
        cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        result_reg <= 0;
    end else if (opn_valid && !res_valid_reg) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sr <= {1'b0, dividend_reg[7:0]};
        neg_divisor <= ~divisor_reg + 1;
        start_cnt <= 1;
        cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            result_reg <= {sr[15:8], sr[7:0]};
            res_valid_reg <= 1;
        end else begin
            if (sr[15:8] >= neg_divisor) begin
                sr <= {sr[14:0], 1'b1};
            end else begin
                sr <= {sr[14:0], 1'b0};
            end
            sr <= sr << 1;
            sr[7:0] <= sr[7:0] - neg_divisor;
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg) begin
        res_valid_reg <= ~opn_valid;
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule