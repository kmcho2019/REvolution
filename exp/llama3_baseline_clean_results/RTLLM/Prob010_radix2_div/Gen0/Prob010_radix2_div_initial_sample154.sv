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
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;
reg res_valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        result_reg <= 16'd0;
        res_valid_reg <= 1'd0;
    end else if (opn_valid &&!res_valid_reg) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sr <= {1'd0, dividend};
        if (sign) begin
            if (divisor[7]) begin
                neg_divisor <= ~divisor + 1'd1;
            end else begin
                neg_divisor <= ~divisor;
            end
        end else begin
            neg_divisor <= ~divisor;
        end
        cnt <= 3'd1;
        start_cnt <= 1'd1;
        result_reg <= 16'd0;
        res_valid_reg <= 1'd0;
    end else if (start_cnt) begin
        if (cnt == 3'd8) begin
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            result_reg <= sr;
            res_valid_reg <= 1'd1;
        end else begin
            reg [8:0] sub_result;
            sub_result <= sr[15:8] - neg_divisor;
            if (sub_result[8]) begin
                sr <= {1'd1, sr[15:1]};
            end else begin
                sr <= {0, sr[15:1] + {8'd0, sub_result[7:0]}};
            end
            cnt <= cnt + 1'd1;
        end
    end else if (res_valid_reg) begin
        if (!opn_valid) begin
            res_valid_reg <= 1'd0;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule