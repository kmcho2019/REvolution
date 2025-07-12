module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]  result
);

// Internal signals and registers
reg    [7:0]   sr;
reg    [7:0]   neg_divisor;
reg    [3:0]   cnt;
reg             start_cnt;
reg             carry_out;

// Initialize dividend and divisor registers
reg    [7:0]   dividend_reg;
reg    [7:0]   divisor_reg;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr              <= 8'b0;
        neg_divisor     <= 8'b0;
        cnt             <= 4'b0;
        start_cnt       <= 1'b0;
        res_valid       <= 1'b0;
        dividend_reg    <= 8'b0;
        divisor_reg     <= 8'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        dividend_reg    <= dividend;
        divisor_reg     <= divisor;
        sr              <= {1'b0, dividend_reg[7:0]}; // Initialize SR with absolute value of dividend
        neg_divisor     <= ~divisor_reg + 1; // Two's complement of divisor
        cnt             <= 4'b1;
        start_cnt       <= 1'b1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 4'b1000) begin
            // Division complete
            cnt         <= 4'b0;
            start_cnt   <= 1'b0;
            res_valid   <= 1'b1;
        end else begin
            // Update SR and increment counter
            carry_out <= sr[7] & (sr[6:0] >= neg_divisor[6:0]);
            sr         <= {carry_out, sr[7:1]} + (carry_out ? 8'b0 : neg_divisor);
            cnt         <= cnt + 1'b1;
        end
    end else if (res_valid && opn_valid) begin
        // Reset result validity when result is consumed
        res_valid <= 1'b0;
    end
end

// Assign output result
assign result = {sr[7:0], sr[7:0]};

endmodule