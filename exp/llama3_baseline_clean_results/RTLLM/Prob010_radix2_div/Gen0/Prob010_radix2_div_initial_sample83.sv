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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [15:0] sr;
reg [7:0] cnt;
reg start_cnt;
reg [15:0] result_reg;

always @(*) begin
    if (sign) begin
        abs_dividend = (~dividend + 1);
        abs_divisor = (~divisor + 1);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
    neg_divisor = ~abs_divisor + 1;
end

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result_reg <= 0;
    end else begin
        if (opn_valid && ~res_valid) begin
            sr <= {1'b0, abs_dividend};
            cnt <= 1;
            start_cnt <= 1;
        end
        if (start_cnt) begin
            if (cnt == 8) begin
                result_reg <= {sr[15:8], sr[7:0]};
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                if (sr[15:8] >= abs_divisor) begin
                    sr <= {1'b1, sr[14:0]};
                end else begin
                    sr <= {1'b0, sr[14:0]};
                end
                cnt <= cnt + 1;
            end
        end
        if (~opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

assign result = result_reg;

endmodule