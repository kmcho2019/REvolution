module radix2_div (
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
reg [8:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg neg_divisor;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        abs_dividend <= (sign? {~dividend[7], dividend[7:0]} + 1 : dividend);
        abs_divisor <= (sign? {~divisor[7], divisor[7:0]} + 1 : divisor);
        sr <= {1'b0, abs_dividend};
        neg_divisor <= ~abs_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            result <= {sr[8:1], sr[0:0]};
            res_valid <= 1;
        end else begin
            reg [8:0] sub;
            sub <= sr - neg_divisor;
            if (sub[8]) begin
                sr <= {1'b0, sr} << 1;
            end else begin
                sr <= {sub[7], (sr[7:0] << 1) | ~sub[8]};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule