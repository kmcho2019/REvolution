module radix2_div(
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // Internal registers
    reg [8:0] SR;          // Shift register: remainder + quotient (9 bits)
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg [8:0] neg_divisor; // two's complement of divisor_abs, 9 bits
    reg [3:0] cnt;         // iteration counter: 1 to 8
    reg       busy;

    // Sign info
    reg       dividend_neg;
    reg       divisor_neg;
    reg       sign_quotient;
    reg       sign_remainder;

    // Subtraction result (10 bits to capture carry/borrow)
    reg [9:0] sub_result;
    reg       borrow_clear;

    // Temporary registers for final quotient and remainder before sign adjustment
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR            <= 9'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            neg_divisor   <= 9'd0;
            cnt           <= 4'd0;
            busy          <= 1'b0;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder<= 1'b0;
        end else begin
            if (opn_valid && !busy && !res_valid) begin
                // Start new division operation

                // Handle division by zero: output zero result and set res_valid immediately
                if (divisor == 8'd0) begin
                    busy      <= 1'b0;
                    res_valid <= 1'b1;
                    result    <= 16'd0;
                    cnt       <= 4'd0;
                    SR        <= 9'd0;
                end else begin
                    if (sign) begin
                        dividend_neg  <= dividend[7];
                        divisor_neg   <= divisor[7];
                        dividend_abs  <= dividend[7] ? (~dividend + 8'd1) : dividend;
                        divisor_abs   <= divisor[7]  ? (~divisor  + 8'd1) : divisor;

                        sign_quotient  <= dividend[7] ^ divisor[7];
                        sign_remainder <= dividend[7];
                    end else begin
                        dividend_neg   <= 1'b0;
                        divisor_neg    <= 1'b0;
                        dividend_abs   <= dividend;
                        divisor_abs    <= divisor;
                        sign_quotient  <= 1'b0;
                        sign_remainder <= 1'b0;
                    end

                    // Initialize shift register: dividend_abs shifted left by 1 with LSB 0 for quotient bit in iteration
                    SR <= {dividend_abs, 1'b0};

                    // Calculate negated divisor: two's complement in 9 bits
                    neg_divisor <= (~{1'b0, divisor_abs} + 9'd1);

                    cnt       <= 4'd1;
                    busy      <= 1'b1;
                    res_valid <= 1'b0;
                    result    <= 16'd0;
                end
            end else if (busy) begin
                // Iterative division process

                // Subtract divisor from upper 9 bits of SR (sign extended)
                sub_result = {1'b0, SR} + {1'b0, neg_divisor};

                // borrow_clear = 1 if no borrow, indicated by carry out (sub_result[9] = 1)
                borrow_clear = sub_result[9];

                if (borrow_clear) begin
                    // Successful subtraction: update SR with subtraction result and set quotient bit = 1
                    SR <= {sub_result[8:0], 1'b1};
                end else begin
                    // Borrow: keep SR upper bits, shift left quotient bit = 0
                    SR <= {SR[7:0], 1'b0};
                end

                if (cnt == 4'd8) begin
                    // Division complete
                    busy  <= 1'b0;
                    res_valid <= 1'b1;
                    cnt   <= 4'd0;

                    // Extract raw quotient and remainder before sign correction
                    quotient_raw  = SR[7:0];
                    remainder_raw = SR[8:1];

                    // Apply sign corrections if signed division
                    if (sign) begin
                        quotient_final  = sign_quotient ? (~quotient_raw + 8'd1) : quotient_raw;
                        remainder_final = sign_remainder ? (~remainder_raw + 8'd1) : remainder_raw;
                    end else begin
                        quotient_final  = quotient_raw;
                        remainder_final = remainder_raw;
                    end

                    // Pack remainder (upper 8 bits) and quotient (lower 8 bits) into result
                    result <= {remainder_final, quotient_final};
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end else if (res_valid && opn_valid) begin
                // Start next operation by clearing res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule