module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result  // [15:8] remainder, [7:0] quotient
);

    // Internal signals and registers
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg       dividend_sign;
    reg       divisor_sign;
    reg       quotient_sign;

    reg [16:0] SR;    // Shift register: 9 bits remainder + 8 bits quotient (total 17 bits)
                       // We'll use SR[16:8] for remainder and SR[7:0] for quotient shifted progressively
    reg [7:0] cnt;
    reg       start_cnt;

    wire [8:0] sub_res; // 9-bit subtraction result to detect borrow
    wire       borrow;  // borrow from subtraction (carry-out inverted)
    wire [16:0] SR_shifted_sub; // tentative next SR after subtraction and shift

    reg [8:0] divisor_9;     // 9-bit divisor aligned for subtraction (upper bits zero extended)

    // Temporary registers to hold subtraction result and updated SR
    reg [8:0] rem_plus_quot;
    reg [16:0] next_SR;

    // Signed division preparation and sign extraction
    wire signed [8:0] dividend_s = {dividend[7], dividend}; // sign extended 9-bit dividend
    wire signed [8:0] divisor_s  = {divisor[7], divisor};   // sign extended 9-bit divisor

    // Calculate absolute values and signs
    always @(*) begin
        if (sign) begin
            dividend_sign = dividend[7];
            divisor_sign = divisor[7];
            abs_dividend = dividend_sign ? (~dividend + 1) : dividend;
            abs_divisor  = divisor_sign  ? (~divisor + 1)  : divisor;
        end else begin
            dividend_sign = 1'b0;
            divisor_sign = 1'b0;
            abs_dividend = dividend;
            abs_divisor  = divisor;
        end
        quotient_sign = dividend_sign ^ divisor_sign;
    end

    // divisor_9: 9-bit divisor for subtraction, aligned with remainder bits (bits [16:8] of SR)
    always @(*) begin
        divisor_9 = {1'b0, abs_divisor}; // zero extend to 9 bits
    end

    // subtraction of divisor from upper remainder bits:
    // SR[16:8] = remainder (9 bits), subtract divisor_9
    assign sub_res = SR[16:8] - divisor_9;
    assign borrow = sub_res[8]; // MSB of sub_res indicates borrow (1 means negative result)

    // Sequential logic for division operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            start_cnt <= 1'b0;
            cnt       <= 8'd0;
            SR        <= 17'd0;
            result    <= 16'd0;
        end else begin
            // Start operation
            if (opn_valid && !res_valid && !start_cnt) begin
                if (abs_divisor == 8'd0) begin
                    // Division by zero, define behavior: output zero quotient and dividend remainder
                    res_valid <= 1'b1;
                    start_cnt <= 1'b0;
                    cnt       <= 8'd0;
                    result    <= {dividend, 8'd0}; // remainder = dividend, quotient=0
                end else begin
                    // Initialize SR: abs_dividend shifted left by 1 bit into bits [16:1] (LSB = 0)
                    // This is to start the iterative division with an extra bit for shifting
                    SR <= {abs_dividend, 8'd0}; // abs_dividend (8 bits) in bits [16:9], zeros [8:0]
                    cnt <= 8'd1;
                    start_cnt <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else if (start_cnt) begin
                if (cnt == 8) begin
                    // Final cycle complete, produce quotient and remainder
                    start_cnt <= 1'b0;
                    cnt <= 8'd0;

                    // Final remainder is in SR[16:8], quotient in SR[7:0]
                    // Adjust signs of quotient and remainder if signed division

                    // Extract raw remainder and quotient
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;
                    reg [7:0] signed_remainder;
                    reg [7:0] signed_quotient;

                    raw_remainder = SR[16:9];  // upper 8 bits of remainder (bits 16 down to 9)
                    raw_quotient = SR[8:1];   // lower 8 bits of quotient (bits 8 down to 1)

                    // Fix remainder and quotient sign
                    // If signed division and quotient_sign==1, quotient = -quotient
                    // If signed division and dividend_sign==1, remainder = -remainder
                    // Note: remainder sign = dividend sign (the remainder has the sign of the dividend)
                    if (sign) begin
                        // quotient sign correction
                        if (quotient_sign) begin
                            signed_quotient = (~raw_quotient + 1'b1);
                        end else begin
                            signed_quotient = raw_quotient;
                        end
                        // remainder sign correction
                        if (dividend_sign) begin
                            signed_remainder = (~raw_remainder + 1'b1);
                        end else begin
                            signed_remainder = raw_remainder;
                        end
                    end else begin
                        // unsigned: just output directly
                        signed_quotient = raw_quotient;
                        signed_remainder = raw_remainder;
                    end

                    // Pack result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {signed_remainder, signed_quotient};
                    res_valid <= 1'b1;

                end else begin
                    // Iteration step cnt=1..7: shift SR left by 1 and subtract if possible

                    // Subtract divisor from remainder part (SR[16:8])
                    if (!borrow) begin
                        // subtraction result >= 0, so set quotient bit to 1
                        SR <= {sub_res[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative, quotient bit = 0, restore remainder
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // After result is read (opn_valid low), clear res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule