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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [8:0] sr; // shift register
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        saved_dividend <= 0;
        saved_divisor <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
    end else begin
        if (opn_valid && !res_valid_reg) begin
            saved_dividend <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8{1'b0}} + dividend[7:0];
            saved_divisor <= sign ? {{7{divisor[7]}}, divisor[7:0]} : {8{1'b0}} + divisor[7:0];
            sr <= {1'b0, saved_dividend[7:0]};
            neg_divisor <= ~saved_divisor + 1;
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                sr <= {sr[7:0], 1'b0};
            end else begin
                reg [8:0] sub_result;
                sub_result <= sr + neg_divisor;
                sr <= sub_result[7:0] ? {1'b1, sr[7:1]} : {1'b0, sr[7:1]};
                cnt <= cnt + 1;
            end
        end

        if (!opn_valid && res_valid_reg) begin
            res_valid_reg <= 0;
        end

        if (!start_cnt && cnt == 0 && opn_valid) begin
            res_valid_reg <= 1;
        end
    end
end

assign result = {sr[8:1], sr[0:7]};
assign res_valid = res_valid_reg;

endmodule