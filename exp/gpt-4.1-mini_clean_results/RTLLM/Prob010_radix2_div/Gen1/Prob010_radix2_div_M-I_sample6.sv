module radix2_div(
    input              clk,
    input              rst,
    input              sign,
    input       [7:0]  dividend,
    input       [7:0]  divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // Internal signals and registers
    reg [8:0]  SR;             // Shift register: remainder+quotient bits (9 bits: [8:0])
    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;
    reg [8:0]  neg_divisor;    // two's complement negated divisor (9 bits)

    reg [3:0]  cnt;            // counter: 0 to 8
    reg        busy;           // division in progress flag

    // Sign information
    reg        dividend_neg;
    reg        divisor_neg;
    reg        sign_quotient;
    reg        sign_remainder;

    // Subtraction temporary (10 bits to capture borrow)
    reg [9:0] sub_result;

    // Combinational signals for subtraction and quotient bit determination
    wire borrow_clear; // true if no borrow (meaning subtraction result >= 0)

    // Determine absolute values and signs at operation start
    // Synchronous process: latch inputs on opn_valid and not busy
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
                // Handle division by zero: if divisor == 0, immediately output 0 result and set res_valid
                if (divisor == 8'd0) begin
                    busy <= 1'b0;
                    res_valid <= 1'b1;
                    result <= 16'd0;
                end else begin
                    // Signed division: compute abs and sign info
                    if (sign) begin
                        dividend_neg  <= dividend[7];
                        divisor_neg   <= divisor[7];
                        dividend_abs  <= dividend[7] ? (~dividend + 8'd1) : dividend;
                        divisor_abs   <= divisor[7]  ? (~divisor + 8'd1)  : divisor;

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

                    // Initialize shift register with dividend_abs shifted left by 1 bit (to hold remainder and quotient)
                    // SR width 9 bits: {8'd dividend_abs, 1'b0}
                    SR <= {dividend_abs, 1'b0};

                    // Calculate two's complement negated divisor in 9 bits for subtraction
                    neg_divisor <= (~{1'b0, divisor_abs} + 9'd1);

                    cnt <= 4'd1;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                    result <= 16'd0;
                end
            end else if (busy) begin
                // Perform iterative division steps
                // Subtract divisor from upper bits of SR
                // sub_result = SR[8:0] + neg_divisor (two's complement subtraction)
                sub_result = {1'b0, SR} + {1'b0, neg_divisor};

                // borrow_clear indicates subtraction did not borrow (sub_result MSB = 1 means no borrow here)
                // But since subtraction is done by adding two's complement neg_divisor,
                // sub_result[9] is carry out; carry out = 1 => no borrow
                borrow_clear = sub_result[9];

                if (borrow_clear) begin
                    // If subtraction successful (no borrow), update SR with sub_result lower 9 bits
                    // Shift left and insert quotient bit '1' at LSB
                    SR <= {sub_result[8:0], 1'b1};
                end else begin
                    // If borrow, restore original SR upper bits, shift left and insert quotient bit '0'
                    SR <= {SR[7:0], 1'b0};
                end

                // Increment counter or finish
                if (cnt == 4'd8) begin
                    busy <= 1'b0;
                    res_valid <= 1'b1;
                    cnt <= 4'd0;

                    // Extract quotient and remainder before sign adjustment
                    // quotient = SR[7:0], remainder = SR[8:1]
                    // Apply sign corrections if signed

                    // Remainder and quotient temporary variables
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    quotient_raw  = SR[7:0];
                    remainder_raw = SR[8:1];

                    if (sign) begin
                        // If quotient sign negative, negate quotient
                        if (sign_quotient)
                            quotient_final = (~quotient_raw + 8'd1);
                        else
                            quotient_final = quotient_raw;

                        // If remainder sign negative, negate remainder
                        if (sign_remainder)
                            remainder_final = (~remainder_raw + 8'd1);
                        else
                            remainder_final = remainder_raw;
                    end else begin
                        // unsigned division: no sign change
                        quotient_final  = quotient_raw;
                        remainder_final = remainder_raw;
                    end

                    result <= {remainder_final, quotient_final};

                end else begin
                    cnt <= cnt + 4'd1;
                end

            end else if (res_valid && opn_valid) begin
                // New operation requested, clear res_valid and start next op on next cycle
                res_valid <= 1'b0;
            end
        end
    end

endmodule