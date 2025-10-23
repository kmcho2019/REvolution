module radix2_div (
    input  clk,
    input  rst,
    input  sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input  opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] sr; // Shift register
reg [7:0] neg_divisor;
reg [3:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [15:0] result_reg; // Result register
reg res_valid_reg; // Result validity register

// Initialize registers and signals
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
    end else begin
        if (opn_valid && !res_valid_reg) begin
            // Save inputs
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            // Initialize shift register and counter
            sr <= {1'b0, dividend_reg};
            neg_divisor <= ~divisor_reg + 1;
            cnt <= 1;
            start_cnt <= 1;
        end
        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result
                cnt <= 0;
                start_cnt <= 0;
                if (sign) begin
                    result_reg <= {dividend_reg[7] ? ~sr + 1 : sr, cnt};
                end else begin
                    result_reg <= {sr[7:0], cnt};
                end
                res_valid_reg <= 1;
            end else begin
                // Perform subtraction and update shift register
                if (sr[7:0] >= divisor_reg) begin
                    sr <= {1'b0, sr[7:0] - divisor_reg, 1'b1};
                end else begin
                    sr <= {1'b0, sr[7:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
        // Result validity
        if (rst || !opn_valid) begin
            res_valid_reg <= 0;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule