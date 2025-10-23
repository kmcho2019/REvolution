module radix2_div (
    input   clk,
    input   rst,
    input   sign,
    input   [7:0] dividend,
    input   [7:0] divisor,
    input   opn_valid,
    output  res_valid,
    output  [15:0] result
);

// Internal signals and registers
reg [15:0] SR; // Shift register for remainder and quotient
reg [7:0] NEG_DIVISOR; // Negated divisor for subtraction
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg result_ready; // Flag to indicate result is ready

// Operation start logic
always @(posedge clk) begin
    if (rst) begin
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
        result_ready <= 1'd0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize internal registers
        abs_dividend <= (sign) ? { {8{dividend[7]}}, dividend[7:0] } : dividend;
        abs_divisor <= (sign) ? { {8{divisor[7]}}, divisor[7:0] } : divisor;
        SR <= {1'd0, abs_dividend}; // Initialize shift register with dividend
        NEG_DIVISOR <= ~abs_divisor + 1; // Negated absolute value of divisor
        cnt <= 1'd1; // Initialize counter
        start_cnt <= 1'd1; // Start division process
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8'd8) begin
            // Division complete
            start_cnt <= 1'd0;
            cnt <= 3'd0;
            if (sign) begin
                // Adjust result for signed operation
                if (dividend[7] != divisor[7]) begin
                    result <= {SR[15:8], ~(SR[7:0]) + 1};
                end else begin
                    result <= SR;
                end
            end else begin
                result <= SR;
            end
            result_ready <= 1'd1;
        end else begin
            // Perform subtraction and update shift register
            reg [8:0] subtract_result;
            subtract_result <= {1'd0, SR[15:8]} - abs_divisor;
            if (subtract_result[8]) begin
                // No borrow, update SR with 0 and quotient bit
                SR <= {1'd0, SR[15:8]} << 1 | 1'd0;
            end else begin
                // Borrow, update SR with 1 and quotient bit
                SR <= {1'd0, SR[15:8]} << 1 | 1'd1;
            end
            cnt <= cnt + 1'd1;
        end
    end
end

// Output validity logic
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else if (result_ready) begin
        res_valid <= 1'd1;
    end else if (!opn_valid && !result_ready) begin
        res_valid <= 1'd0;
    end
end

endmodule