module radix2_div (
    input              clk,
    input              rst,
    input              sign,         // 1: signed division, 0: unsigned
    input       [7:0]  dividend,
    input       [7:0]  divisor,
    input              opn_valid,
    output reg         res_valid,
    output      [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_mag, divisor_mag;

    // Shift register SR: {remainder[8:0], quotient[7:0]} total 17 bits
    reg [16:0] SR;

    // Negative divisor magnitude for subtraction
    reg [8:0] NEG_DIVISOR; // 9 bits to match remainder width

    // Counter: counts from 0 to 8 for 8 division steps
    reg [3:0] cnt;

    // Signals for addition and carry detection
    wire [8:0] remainder = SR[16:8];
    wire [8:0] sum;       // remainder + NEG_DIVISOR
    wire       carry_out; // carry out from addition

    // Register for adjusted quotient and remainder at end
    reg [7:0] quotient_final, remainder_final;

    // Flags for sign correction
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Add remainder and NEG_DIVISOR (two's complement subtraction)
    assign {carry_out, sum} = {1'b0, remainder} + {1'b0, NEG_DIVISOR};

    // Result output
    reg [15:0] result_reg;

    assign result = result_reg;

    // Control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_r    <= 8'd0;
            divisor_r     <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            dividend_mag  <= 8'd0;
            divisor_mag   <= 8'd0;
            NEG_DIVISOR   <= 9'd0;
            SR            <= 17'd0;
            cnt           <= 4'd0;
            quotient_final<= 8'd0;
            remainder_final<=8'd0;
            result_reg    <= 16'd0;
            res_valid     <= 1'b0;
        end else begin
            if (res_valid && !opn_valid) begin
                // Clear res_valid when result has been consumed (opn_valid low)
                res_valid <= 1'b0;
            end

            if (!res_valid) begin
                if (opn_valid && divisor != 8'd0) begin
                    // Latch inputs
                    dividend_r <= dividend;
                    divisor_r  <= divisor;

                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg  <= divisor[7];
                        dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                        divisor_mag  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg  <= 1'b0;
                        dividend_mag <= dividend;
                        divisor_mag  <= divisor;
                    end

                    // Prepare NEG_DIVISOR = -divisor_mag (9-bit)
                    NEG_DIVISOR <= (~{1'b0, divisor_mag} + 9'd1);

                    // Initialize SR: remainder= dividend_mag shifted left 1 bit (lowest bit zero), quotient bits zeroed
                    // But per the algorithm, remainder is in bits [16:8], quotient in [7:0]
                    // We load dividend_mag into quotient bits initially, remainder=0
                    // Then shift left by 1 bit to start division steps with initial shift
                    // So initial SR: remainder=0, quotient=dividend_mag, then shift left 1 (done as first step)
                    SR <= {9'd0, dividend_mag};

                    cnt <= 4'd0;
                    res_valid <= 1'b0;
                end else if (cnt < 4'd8) begin
                    // Perform division step

                    // Step 1: shift SR left by 1 bit
                    SR <= {SR[15:0], 1'b0};

                    // Step 2: after shift, add NEG_DIVISOR to remainder portion
                    // sum and carry_out computed combinationally from current SR (before update)
                    // But SR is updated above with shift - To sequence correctly,
                    // use a pipeline: first shift, then next cycle add/subtract

                    // Here to comply with synchronous logic,
                    // perform subtraction in the next clock cycle using a register stage.
                    // So we introduce intermediate registers for remainder and quotient update

                    // To solve this cleanly, use a registered approach:

                    // For this coding block, we need to sequence the operations carefully.
                    // Instead, let's re-implement the algorithm as a two-cycle pipeline per step:
                    // - cycle n: shift left
                    // - cycle n+1: add NEG_DIVISOR and update quotient bit accordingly

                    // However, problem description suggests all in one clock cycle.

                    // So instead, do addition using current remainder (before shift),
                    // update SR in the next cycle.

                    // Solution: Implement this in a separate always block below.

                    cnt <= cnt + 1'b1;

                    // res_valid clear until done
                    res_valid <= 1'b0;

                end else if (cnt == 4'd8) begin
                    // Division complete: fix quotient and remainder sign and output

                    // Extract raw quotient and remainder
                    // quotient in SR[7:0], remainder in SR[16:9] (8 bits from 9-bit remainder)
                    // Because remainder is 9 bits but quotient 8 bits, remainder is top 9 bits, quotient low 8 bits
                    // We take remainder = SR[16:9], which is 8 bits (ignoring the LSB of remainder)

                    quotient_final  <= quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];
                    remainder_final <= remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];

                    result_reg <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;

                    cnt <= 4'd9; // Stall counter beyond 8 to hold results
                end else begin
                    // wait for result consumed
                    if (!opn_valid) begin
                        // Reset for next operation
                        res_valid <= 1'b0;
                        cnt <= 4'd0;
                    end
                end
            end
        end
    end

    // Because SR update and subtraction logic require combinational decisions,
    // implement a combinational process that prepares the next SR value based on sum and carry_out

    // Next SR value combinationally: used only when cnt in 0..7 (division steps)
    // But since SR is updated inside always @(posedge clk), this block computes next value for SR

    reg [16:0] SR_next;

    always @(*) begin
        // Default next SR is current SR (no change)
        SR_next = SR;

        if (rst) begin
            SR_next = 17'd0;
        end else if (!res_valid && (cnt < 4'd8)) begin
            // Step 1: shift SR left by 1 bit
            // Shift left by 1: SR shifted left (LSB zero)
            reg [16:0] SR_shifted;
            SR_shifted = {SR[15:0], 1'b0};

            // Step 2: add NEG_DIVISOR to upper 9 bits (remainder portion)
            reg [8:0] rem_shifted;
            rem_shifted = SR_shifted[16:8];

            reg [8:0] sum_tmp;
            reg carry_tmp;
            {carry_tmp, sum_tmp} = rem_shifted + NEG_DIVISOR;

            if (carry_tmp) begin
                // No borrow, accept subtraction, set quotient LSB to 1
                // quotient bits are SR_shifted[7:0]
                SR_next = {sum_tmp, SR_shifted[7:1], 1'b1};
            end else begin
                // Borrow occurred, restore remainder, quotient bit 0
                SR_next = {rem_shifted, SR_shifted[7:1], 1'b0};
            end
        end
    end

    // Update SR with computed SR_next synchronously
    // This must be a separate always block or carefully sequenced within the main block.

    // To avoid multiple drivers for SR, we implement SR update here:

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
        end else if (!res_valid && (cnt < 4'd8)) begin
            SR <= SR_next;
        end
    end

endmodule