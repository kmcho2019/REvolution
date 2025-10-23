module radix2_div (
    input            clk,
    input            rst,
    input            sign,
    input    [7:0]   dividend,
    input    [7:0]   divisor,
    input            opn_valid,
    output           res_valid,
    output   [15:0]  result
);

reg     [7:0]        div, dvs;
reg     [15:0]       sr;
reg     [7:0]        neg_dvs;
reg     [2:0]        cnt;
reg                 start_cnt;
reg                 res_valid_reg;

wire    [7:0]        dvs_abs;
wire    [7:0]        div_abs;
wire    [8:0]        sub_result;
wire                 carry_out;

assign dvs_abs = sign? { {7{dvs[7]}}, dvs[7:0] } : dvs;
assign div_abs = sign? { {7{div[7]}}, div[7:0] } : div;
assign sub_result = {1'b0, sr[7:0]} - dvs_abs;
assign carry_out = sub_result[8];

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        div <= 8'd0;
        dvs <= 8'd0;
        sr <= 16'd0;
        neg_dvs <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && ~res_valid_reg) begin
        div <= dividend;
        dvs <= divisor;
        sr <= { {8{1'b0}}, div_abs };
        neg_dvs <= ~dvs_abs + 1'b1;
        cnt <= 1;
        start_cnt <= 1'b1;
        res_valid_reg <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            sr <= { div_abs, cnt - 1 };
            cnt <= 3'd0;
            start_cnt <= 1'b0;
            res_valid_reg <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            if (carry_out) begin
                sr <= { sr[14:0], 1'b1 };
            end else begin
                sr <= { sr[14:0], 1'b0 };
            end
            sr <= { sub_result[7:0], sr[15:8] };
        end
    end else if (res_valid_reg) begin
        res_valid_reg <= 1'b0;
    end
end

assign res_valid = res_valid_reg;
assign result = { sr[15:8], sr[7:0] };

endmodule