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

reg [7:0] sr;         // Shift register to hold the dividend
reg [7:0] neg_divisor; // Negated absolute value of the divisor
reg [2:0] cnt;        // Counter for the division process
reg       start_cnt;  // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor;  // Absolute value of the divisor
reg       neg_result;   // Flag to indicate if the result is negative

always @(*) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt       <= 1'b0;
        start_cnt <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize shift register SR and counter cnt
        abs_dividend <= (sign && dividend[7])? (~dividend + 1) : dividend;
        abs_divisor  <= (sign && divisor[7])? (~divisor + 1) : divisor;
        neg_divisor  <= (~abs_divisor + 1);
        sr           <= {1'b0, abs_dividend};
        cnt           <= 1'b1;
        start_cnt    <= 1'b1;
        neg_result   <= (sign && (dividend[7] ^ divisor[7]));
    end
end

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        sr       <= 8'b0;
        cnt       <= 1'b0;
        start_cnt <= 1'b0;
    end else if (start_cnt) begin
        // Perform division process
        if (cnt == 8) begin
            // Division is complete
            cnt       <= 1'b0;
            start_cnt <= 1'b0;
            if (neg_result) begin
                // If the result is negative, negate the quotient and remainder
                result <= {8'b0, ~sr[7:0] + 1};
            end else begin
                result <= {sr[7:0], sr[7:0]};
            end
            res_valid <= 1'b1;
        end else begin
            // Compute subtraction result and update SR
            reg [8:0] sub_result;
            sub_result <= sr - {1'b0, neg_divisor};
            if (sub_result[8]) begin
                // If there is a borrow, shift SR left and insert 0
                sr <= {1'b0, sr[7:1]};
            end else begin
                // If there is no borrow, shift SR left and insert 1
                sr <= {1'b1, sr[7:1]};
            end
            cnt       <= cnt + 1'b1;
        end
    end else if (res_valid &&!opn_valid) begin
        // Reset res_valid when the result is consumed
        res_valid <= 1'b0;
    end
end

endmodule