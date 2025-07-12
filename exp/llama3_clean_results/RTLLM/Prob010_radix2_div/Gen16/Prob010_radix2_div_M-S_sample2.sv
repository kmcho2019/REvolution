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
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        sr <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (sign) begin
                if (dividend[7]) begin
                    sr <= {1'b0, ~dividend + 1};
                end else begin
                    sr <= {1'b0, dividend};
                end
                if (divisor[7]) begin
                    abs_divisor <= ~divisor + 1;
                    neg_divisor <= divisor;
                end else begin
                    abs_divisor <= divisor;
                    neg_divisor <= ~divisor + 1;
                end
            end else begin
                sr <= {1'b0, dividend};
                abs_divisor <= divisor;
                neg_divisor <= ~divisor + 1;
            end
            cnt <= 1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 3'd8) begin
                res_valid <= 1;
                result <= {sr[15:8], sr[7:0]};
                start_cnt <= 0;
            end else begin
                if (sr[15:8] >= abs_divisor) begin
                    sr <= {sr[15:8] - abs_divisor, 1'b1, sr[7:1]};
                end else begin
                    sr <= {sr[15:8], 1'b0, sr[7:1]};
                end
                cnt <= cnt + 1'b1;
            end
        end

        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule