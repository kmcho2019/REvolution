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
reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;

assign res_valid = (cnt == 0) && start_cnt;
assign result = result_reg;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        result_reg <= 16'd0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sr <= {1'd0, (sign)? (~dividend + 1) : dividend};
        neg_divisor <= (sign)? (~divisor + 1) : divisor;
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end else if (start_cnt) begin
        if (cnt == 3'd8) begin
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            result_reg <= {sr[7:0], sr[7:0]};
        end else begin
            reg [8:0] sub;
            sub <= {1'd0, sr[7:0]} - neg_divisor;
            sr <= {sub[8], (sub[8])? sr[7:0] : (sr[7:0] + neg_divisor)};
            cnt <= cnt + 1'd1;
        end
    end else if (!opn_valid && res_valid) begin
        result_reg <= 16'd0;
    end
end

endmodule