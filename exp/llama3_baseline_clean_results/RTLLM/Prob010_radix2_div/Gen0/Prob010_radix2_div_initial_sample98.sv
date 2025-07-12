module radix2_div(
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output            res_valid,
    output     [15:0] result
);

reg [15:0] sr; // Shift register for remainder and quotient
reg [7:0]  neg_divisor; // Negated absolute value of divisor
reg [2:0]  cnt; // Counter for division steps
reg        start_cnt; // Flag to start the division process
reg        res_valid_r; // Register for result validity

// Initialize values when operation is valid and result is not
always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_r <= 0;
    end else if (opn_valid &&!res_valid_r) begin
        // Save inputs
        sr <= {1'b0, (sign? ~dividend[7] : 1'b0), dividend[7:0]} << 1;
        neg_divisor <= (sign? ~divisor[7] : 1'b0)? {~divisor[7:0]} + 1 : divisor;
        cnt <= 1;
        start_cnt <= 1;
        res_valid_r <= 0;
    end else if (start_cnt) begin
        // Perform division steps
        if (cnt == 8) begin
            // Division complete, update result and signals
            result <= {sr[15:8], sr[7:0]};
            res_valid_r <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Update shift register and counter
            reg [8:0] sub;
            sub <= {1'b0, sr[15:8]} - neg_divisor;
            if (sub[8]) begin
                // If subtraction result is negative, no borrow
                sr <= {1'b0, sr[15:8]} << 1;
            end else begin
                // If subtraction result is non-negative, borrow
                sr <= {1'b1, sr[15:8]} << 1;
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid_r &&!opn_valid) begin
        // Reset result validity if no operation is pending
        res_valid_r <= 0;
    end
end

assign res_valid = res_valid_r;

endmodule