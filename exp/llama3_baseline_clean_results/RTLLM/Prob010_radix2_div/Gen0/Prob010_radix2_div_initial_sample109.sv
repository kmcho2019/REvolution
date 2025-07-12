module radix2_div(
    input  clk,
    input  rst,
    input  sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input  opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] sr; // shift register
reg [8:0] neg_divisor;
reg [3:0] cnt; // counter
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
            divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
            // Initialize registers
            sr <= {1'b0, dividend_reg[7:0]};
            neg_divisor <= ~divisor_reg + 1;
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete
                cnt <= 0;
                start_cnt <= 0;
                res_valid <= 1;
                result <= {sr[8:1], sr[0]};
            end else begin
                // Update shift register
                if (sr[8] == 1) begin
                    sr <= {sr[8:1] + neg_divisor, 1'b1};
                end else begin
                    sr <= {sr[8:1] - neg_divisor, 1'b0};
                end
                // Increment counter
                cnt <= cnt + 1;
            end
        end else if (res_valid) begin
            // Wait for result to be consumed
            if (!opn_valid) begin
                res_valid <= 0;
            end
        end
    end
end

endmodule