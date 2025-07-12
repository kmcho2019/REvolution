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
reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [3:0] cnt; // Counter for 8-bit division
reg start_cnt; // Flag to start the division process
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg res_valid_reg; // Register for result validity

assign result = {remainder, quotient};

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
    end else begin
        if (opn_valid &&!res_valid_reg) begin
            // Initialize registers and counters
            if (sign) begin
                // Signed division
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end else begin
                // Unsigned division
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            sr <= {1'b0, dividend_reg}; // Initialize shift register
            neg_divisor <= ~divisor_reg + 1; // Negated absolute value of divisor
            cnt <= 1;
            start_cnt <= 1;
            res_valid_reg <= 0;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8) begin
                // Division complete
                cnt <= 0;
                start_cnt <= 0;
                remainder <= sr[15:8]; // Final remainder
                quotient <= sr[7:0]; // Final quotient
                res_valid_reg <= 1;
            end else begin
                // Update shift register and counter
                reg [8:0] temp; // Temporary result
                temp <= sr[15:8] - divisor_reg;
                if (temp[8]) begin
                    // Borrow, subtract divisor
                    sr <= {1'b1, sr[15:8] - divisor_reg, sr[7:1]};
                end else begin
                    // No borrow, add divisor
                    sr <= {1'b0, sr[15:8] + divisor_reg, sr[7:1]};
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid_reg) begin
            // Result has been consumed, reset result validity
            res_valid_reg <= 0;
        end
    end
end

assign res_valid = res_valid_reg;

endmodule