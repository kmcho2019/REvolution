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

reg [15:0] sr;
reg [7:0] neg_divisor;
reg [7:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            sr <= {1'b0, sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend};
            neg_divisor <= sign ? (~divisor + 1) : divisor;
            cnt <= 8'd1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 8'd8) begin
                res_valid <= 1;
                result <= {sr[15:8], sr[7:0]};
                start_cnt <= 0;
            end else begin
                if (sr[15:8] >= neg_divisor) begin
                    sr <= {sr[15:8] - neg_divisor, 1'b1, sr[7:1]};
                end else begin
                    sr <= {sr[15:8], 1'b0, sr[7:1]};
                end
                cnt <= cnt + 1'd1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule