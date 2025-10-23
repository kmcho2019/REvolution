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

// Internal signals and registers
reg [7:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg res_valid_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [15:0] result_reg;

// Initialize the internal state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the internal state
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        res_valid_reg <= 1'b0;
        quotient <= 8'b0;
        remainder <= 8'b0;
        result_reg <= 16'b0;
    end else begin
        // Save the inputs when opn_valid is high and res_valid is low
        if (opn_valid && !res_valid_reg) begin
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            // Initialize the shift register with the absolute value of the dividend shifted left by one bit
            sr <= {1'b0, dividend_reg[7:0]};
            // Set NEG_DIVISOR to the negated absolute value of the divisor
            neg_divisor <= ~divisor_reg + 1'b1;
            // Set the counter cnt to 1 and start_cnt to 1 to begin the division process
            cnt <= 3'b001;
            start_cnt <= 1'b1;
        end

        // Perform the division process
        if (start_cnt) begin
            // If the counter cnt reaches 8, the division is complete
            if (cnt == 3'b111) begin
                // Clear the counter and start_cnt
                cnt <= 3'b0;
                start_cnt <= 1'b0;
                // Update the shift register with the final remainder and quotient
                result_reg <= {remainder, quotient};
                // Set res_valid to high
                res_valid_reg <= 1'b1;
            end else begin
                // Increment the counter
                cnt <= cnt + 1'b1;
                // Update the shift register based on the subtraction result
                reg [8:0] sub_result;
                sub_result <= {1'b0, sr[7:0]} - {1'b0, neg_divisor[7:0]};
                if (sub_result[8]) begin
                    // If the result is negative, shift the shift register left and insert a 1
                    sr <= {1'b1, sr[7:1]};
                end else begin
                    // If the result is non-negative, shift the shift register left and insert a 0
                    sr <= {1'b0, sr[7:1]};
                    // Update the quotient
                    quotient <= quotient + 1'b1;
                end
                // Update the remainder
                remainder <= sr[7:0];
            end
        end

        // Manage res_valid based on the reset signal, the counter, and whether the result has been consumed
        if (rst) begin
            res_valid_reg <= 1'b0;
        end else if (opn_valid && !res_valid_reg) begin
            // Reset res_valid when a new operation is requested
            res_valid_reg <= 1'b0;
        end else if (res_valid_reg && !opn_valid) begin
            // Set res_valid to low when the result has been consumed
            res_valid_reg <= 1'b0;
        end
    end
end

// Assign the outputs
assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule