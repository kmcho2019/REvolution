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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] sr;  // shift register with 1 extra bit for carry
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg [3:0] cnt;  // counter
reg start_cnt;  // flag to start division

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Save inputs
            dividend_reg <= dividend;
            divisor_reg <= divisor;

            // Initialize registers
            if (sign) begin
                // Signed division
                sr <= {1'b0, (dividend_reg[7]? (~dividend_reg + 1) : dividend_reg)};  // shift left by one bit
                neg_divisor <= ~(divisor_reg[7]? (~divisor_reg + 1) : divisor_reg) + 1;  // negated absolute value of divisor
            end else begin
                // Unsigned division
                sr <= {1'b0, dividend_reg};  // shift left by one bit
                neg_divisor <= ~divisor_reg + 1;  // negated absolute value of divisor
            end
            cnt <= 1;
            start_cnt <= 1;
        end

        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                cnt <= 0;
                result <= {sr[8:1], sr[0]};  // update result
                res_valid <= 1;
            end else begin
                // Update shift register
                if (sr[8] == 0) begin
                    // Subtract NEG_DIVISOR
                    if (sr[7:0] < neg_divisor) begin
                        sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b0, sr[7:0] - neg_divisor} << 1;  // shift left and insert carry-out
                    end
                end else begin
                    // Subtract NEG_DIVISOR
                    if ({sr[8], sr[7:0]} < {1'b0, neg_divisor}) begin
                        sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b0, sr[7:0] - neg_divisor} << 1;  // shift left and insert carry-out
                    end
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule