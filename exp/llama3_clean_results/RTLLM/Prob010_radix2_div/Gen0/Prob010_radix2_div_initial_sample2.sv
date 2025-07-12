module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]  result
);

reg [15:0] SR; // Shift Register for dividend and remainder
reg [7:0]  NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0]  cnt; // Counter for division process
reg         start_cnt; // Flag to indicate division start
reg         first_op; // Flag to track if it's the first operation
reg [7:0]  abs_dividend; // Absolute value of dividend
reg [7:0]  abs_divisor; // Absolute value of divisor

// Determine absolute values and sign of dividend and divisor
always @(dividend, divisor, sign) begin
    if (sign) begin
        abs_dividend = (dividend[7]) ? (~dividend + 1) : dividend;
        abs_divisor = (divisor[7]) ? (~divisor + 1) : divisor;
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

// Control logic
always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        first_op <= 1;
    end else if (opn_valid && !res_valid) begin
        // Initialize for new operation
        SR <= {1'b0, abs_dividend}; // Shift dividend left by one bit
        NEG_DIVISOR <= ~abs_divisor + 1; // Negated absolute value of divisor
        cnt <= 1;
        start_cnt <= 1;
        first_op <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result
            res_valid <= 1;
            start_cnt <= 0;
            cnt <= 0;
            result <= {SR[15:8], SR[7:0]};
        end else begin
            // Update SR based on subtraction result
            if (SR[15:8] >= NEG_DIVISOR) begin
                SR <= {SR[14:0], 1} - {NEG_DIVISOR, 8'b0};
            end else begin
                SR <= {SR[14:0], 0};
            end
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0; // Reset result validity when result is consumed
    end
end

endmodule