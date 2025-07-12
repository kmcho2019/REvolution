module radix2_div (
    input clk, rst, sign, opn_valid,
    input [7:0] dividend, divisor,
    output res_valid,
    output [15:0] result
);

reg [7:0] neg_divisor;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;

wire [7:0] sub_result;
wire cout;

assign sub_result = sr[7:0] - neg_divisor;
assign cout = ~sub_result[7];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
    end else if (opn_valid && ~res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (sign) begin
            neg_divisor <= ~divisor_reg + 1;
            sr <= {1'd0, dividend_reg[7]? ~dividend_reg + 1 : dividend_reg};
        end else begin
            neg_divisor <= ~divisor_reg + 1;
            sr <= {1'd0, dividend_reg};
        end
        cnt <= 3'd1;
        start_cnt <= 1'd1;
        res_valid <= 1'd0;
    end else if (start_cnt) begin
        if (cnt == 3'd8) begin
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            if (sign) begin
                if (dividend_reg[7] ^ divisor_reg[7]) begin
                    result <= {sr[15:8], ~sr[7:0] + 1};
                end else begin
                    result <= {sr[15:8], sr[7:0]};
                end
            end else begin
                result <= {sr[15:8], sr[7:0]};
            end
            res_valid <= 1'd1;
        end else begin
            cnt <= cnt + 3'd1;
            if (~cout) begin
                sr <= {1'd0, sr[14:1]};
            end else begin
                sr <= {cout, sr[14:1]} + {8'd0, neg_divisor};
            end
        end
    end else if (res_valid) begin
        res_valid <= 1'd0;
    end
end

endmodule