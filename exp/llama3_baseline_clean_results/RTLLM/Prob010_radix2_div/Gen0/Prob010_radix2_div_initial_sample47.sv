module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]    dividend,
    input   [7:0]    divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]   result
);

reg [7:0]          dividend_reg;
reg [7:0]          divisor_reg;
reg [8:0]          sr;      // Shift register with 9 bits
reg [3:0]          cnt;     // Counter with 4 bits
reg               start_cnt;  // Start counter flag
reg               neg_divisor; // Negated divisor
reg [15:0]         result_reg;

always @(posedge clk) begin
    if (rst) begin
        // Reset all registers
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        neg_divisor <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            // Initialize shift register with absolute value of dividend shifted left by one bit
            sr <= {dividend_reg[7], dividend_reg};
            // Set negated divisor
            if (sign) begin
                neg_divisor <= ~divisor_reg[7] + 1;
            end else begin
                neg_divisor <= divisor_reg;
            end
            // Set counter and start counter flag
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            // Perform division process
            if (cnt == 8) begin
                // Division is complete, clear counter and start counter flag
                cnt <= 0;
                start_cnt <= 0;
                // Update result register
                result_reg <= {sr[8:1], sr[0]};
            end else begin
                // Increment counter
                cnt <= cnt + 1;
                // Compute subtraction
                if (sr[8] == 0) begin
                    // No borrow, update shift register
                    sr <= {sr[7:0], 0};
                end else begin
                    // Borrow, update shift register with borrow
                    sr <= {sr[7:0], 1};
                end
                // Update shift register based on subtraction result
                if (sr[8] == neg_divisor[7]) begin
                    // No carry-out, update shift register
                    sr <= sr - {neg_divisor, 0};
                end else begin
                    // Carry-out, update shift register with carry-out
                    sr <= {sr[8:1], sr[0]};
                end
            end
        end
        // Manage result validity
        if (rst || !opn_valid) begin
            res_valid <= 0;
        end else if (start_cnt && cnt == 8) begin
            res_valid <= 1;
        end
        // Update output result
        result <= result_reg;
    end
end

endmodule