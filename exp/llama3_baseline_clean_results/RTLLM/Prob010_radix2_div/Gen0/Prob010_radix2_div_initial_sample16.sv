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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for bits processed
reg start_cnt; // Flag to start the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg neg_result; // Flag to indicate negative result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
        result <= 16'd0;
    end else if (opn_valid && !res_valid) begin
        // Initialize registers and start division
        abs_dividend <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
        abs_divisor <= (sign && divisor[7]) ? (~divisor + 1) : divisor;
        SR <= {1'd0, abs_dividend};
        NEG_DIVISOR <= (~abs_divisor + 1);
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 3'd8) begin
            // Division complete
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            // Update result based on the sign of the original dividend and divisor
            if (sign) begin
                if ((dividend[7] ^ divisor[7])) begin
                    // Different signs, result is negative
                    neg_result <= 1'd1;
                end else begin
                    // Same signs, result is positive
                    neg_result <= 1'd0;
                end
            end else begin
                // Unsigned, result is always positive
                neg_result <= 1'd0;
            end
            // Construct the final result with remainder and quotient
            result <= {SR[15:8], SR[7:0]};
            res_valid <= 1'd1;
        end else begin
            // Continue division
            if (SR[15] == 1'd0) begin
                // No borrow, shift left and insert 0
                SR <= {SR[14:0], 1'd0};
            end else begin
                // Borrow, subtract and shift left with 1
                SR <= {SR[14:0], 1'd1} - {NEG_DIVISOR, 8'd0};
            end
            cnt <= cnt + 1'd1;
        end
    end else if (res_valid && ~opn_valid) begin
        // Reset result validity when not used
        res_valid <= 1'd0;
    end
end

endmodule