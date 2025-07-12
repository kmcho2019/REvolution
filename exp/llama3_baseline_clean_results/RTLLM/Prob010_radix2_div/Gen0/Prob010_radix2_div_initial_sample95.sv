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

// Internal signals
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter signal
reg [7:0] remainder;  // Final remainder
reg [7:0] quotient;  // Final quotient
reg carry_out;  // Carry-out from subtraction
reg sub_result;  // Result of subtraction

// Load inputs into internal registers
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
    end else if (opn_valid &&!res_valid) begin
        if (sign) begin
            dividend_reg <= {8{dividend[7]}} ^ dividend;  // Two's complement for signed
            divisor_reg <= {8{divisor[7]}} ^ divisor;
        end else begin
            dividend_reg <= dividend;
            divisor_reg <= divisor;
        end
    end
end

// Initialize shift register, negated divisor, and counter
always @(posedge clk) begin
    if (rst) begin
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
    end else if (opn_valid &&!res_valid) begin
        sr <= {dividend_reg[7:0], 1'd0};  // Initialize shift register
        neg_divisor <= ~divisor_reg + 1;  // Negated absolute value of divisor
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end
end

// Division process
always @(posedge clk) begin
    if (rst) begin
        remainder <= 8'd0;
        quotient <= 8'd0;
        carry_out <= 1'd0;
    end else if (start_cnt) begin
        if (cnt == 3'd8) begin
            // Division complete, update remainder and quotient
            remainder <= sr[15:8];
            quotient <= sr[7:0];
            start_cnt <= 1'd0;
            cnt <= 3'd0;
        end else begin
            // Compute subtraction
            sub_result <= sr[15]? 1'd0 : 1'd1;  // 1 if no borrow, 0 if borrow
            carry_out <= sr[15]? 1'd1 : 1'd0;
            sr <= {sub_result, sr[14:1]} - {8'd0, neg_divisor};  // Update shift register
            cnt <= cnt + 1'd1;
        end
    end
end

// Update result and manage result validity
always @(posedge clk) begin
    if (rst) begin
        result <= 16'd0;
        res_valid <= 1'd0;
    end else if (!start_cnt && cnt == 3'd0) begin
        // Update result
        result <= {remainder, quotient};
        res_valid <= 1'd1;
    end else if (opn_valid &&!res_valid) begin
        res_valid <= 1'd0;
    end
end

endmodule