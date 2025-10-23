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
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] temp;
reg [15:0] final_result;
reg result_consumed;

assign res_valid = (cnt == 8) && start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result_consumed <= 1;
        final_result <= 0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
        sr <= {1'b0, dividend_reg};
        neg_divisor <= ~divisor_reg + 1;
        cnt <= 1;
        start_cnt <= 1;
        result_consumed <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            final_result <= sr;
        end else begin
            temp <= sr - neg_divisor;
            sr <= {temp[15], (temp[15]? (sr[6:0] + 1) : sr[6:0]), 1'b0};
            cnt <= cnt + 1;
        end
    end else if (result_consumed) begin
        final_result <= 0;
    end

    if (res_valid &&!result_consumed) begin
        result_consumed <= 1;
        final_result <= sr;
    end
end

always @(posedge clk) begin
    if (res_valid) begin
        result <= final_result;
    end else begin
        result <= 0;
    end
end

endmodule