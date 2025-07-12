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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [7:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] tmp_result;
reg carry_out;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
    end
    else if (opn_valid && !res_valid) begin
        // Save inputs
        abs_dividend <= (sign ? {~dividend[7] & ~dividend[6:0] + 1} : dividend);
        abs_divisor <= (sign ? {~divisor[7] & ~divisor[6:0] + 1} : divisor);
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end
    else if (start_cnt) begin
        // Perform division
        tmp_result <= sr[7:0] - neg_divisor;
        carry_out <= (tmp_result[7] == 1) ? 1 : 0;
        sr <= {carry_out, sr[7:0]};
        if (cnt == 8) begin
            // Update result
            result <= {sr[7:0], sr[7:0]};
            res_valid <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
    else if (res_valid) begin
        // Result is valid
        if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule