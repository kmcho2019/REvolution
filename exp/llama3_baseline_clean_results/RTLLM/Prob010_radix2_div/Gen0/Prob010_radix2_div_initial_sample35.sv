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

reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] tmp_result;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend <= (sign)? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign)? {~divisor[7], divisor[7:0]} + 1 : divisor;
        neg_divisor <= (sign)? {~abs_divisor[7], abs_divisor[7:0]} + 1 : ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
            tmp_result <= sr[7:0];
            result <= {sr[15:8], tmp_result};
        end else begin
            if (sr[15:8] >= neg_divisor) begin
                sr <= {sr[14:0], 1'b0} - {neg_divisor, 8'b0};
            end else begin
                sr <= {sr[14:0], 1'b1};
            end
            cnt <= cnt + 1;
        end
    end
end

always @ (posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 0;
    end
end

endmodule