module radix2_div (
    input        clk,
    input        rst,
    input        sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input        opn_valid,
    output       res_valid,
    output [15:0] result
);

reg [15:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] final_result;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;

assign res_valid = (cnt == 8 && start_cnt);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        final_result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            abs_dividend <= sign ? {~dividend[7], dividend[7:0]} + 1 : dividend;
            abs_divisor <= sign ? {~divisor[7], divisor[7:0]} + 1 : divisor;
            sr <= {abs_dividend[7:0], 1'b0};
            neg_divisor <= {~abs_divisor[7:0], 1'b0} + 1;
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                if (sign && (dividend[7] != divisor[7])) begin
                    final_result <= {~sr[15:8] + 1, ~sr[7:0] + 1};
                end else begin
                    final_result <= sr;
                end
            end else begin
                cnt <= cnt + 1;
                if (sr[15:8] >= neg_divisor) begin
                    sr <= {1'b1, sr[15:8] - neg_divisor, sr[7:1]};
                end else begin
                    sr <= {1'b0, sr[15:8], sr[7:1]};
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (cnt == 8 && start_cnt) begin
        result <= final_result;
    end
end

endmodule