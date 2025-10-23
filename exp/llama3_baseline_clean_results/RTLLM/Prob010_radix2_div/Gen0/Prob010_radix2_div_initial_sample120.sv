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

reg [7:0] sr_dividend;
reg [7:0] neg_divisor;
reg [7:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
wire [8:0] sub_result;
wire carry_out;

assign sub_result = {1'b0, sr} - neg_divisor;
assign carry_out = ~sub_result[8];

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        dividend_abs <= 8'b0;
        divisor_abs <= 8'b0;
        result <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        // save inputs
        dividend_abs <= sign ? (~dividend + 1) : dividend;
        divisor_abs <= sign ? (~divisor + 1) : divisor;
        sr <= {1'b0, dividend_abs};
        neg_divisor <= ~divisor_abs + 1;
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            result <= {sr[7:0], sr[7:0] - neg_divisor};
            res_valid <= 1'b1;
        end else if (carry_out) begin
            sr <= {1'b1, sr[7:0]};
            cnt <= cnt + 1;
        end else begin
            sr <= {1'b0, sr[7:0]} + sub_result[7:0];
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule