module radix2_div (
    input            clk,
    input            rst,
    input            sign,           // 1: signed, 0: unsigned
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,
    output reg       res_valid,
    output     [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;         // {remainder[8:0], quotient[7:0]} combined
    reg [7:0]  dividend_r;
    reg [7:0]  divisor_r;
    reg        dividend_neg;
    reg        divisor_neg;

    reg [7:0]  dividend_mag;
    reg [7:0]  divisor_mag;

    reg        running;
    reg [3:0]  count;      // counts from 0 to 8

    // Signals for subtraction: combinational
    wire [8:0] remainder = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_mag};
    wire [8:0] sub = remainder - divisor_ext;
    wire       borrow = sub[8];

    // Corrected final quotient and remainder
    reg [7:0] quotient_corr;
    reg [7:0] remainder_corr;

    // Sign flags for final correction
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Output register
    reg [15:0] result_reg;

    // Store final outputs
    assign result = result_reg;

    // On opn_valid when not running, latch inputs and start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'd0;
            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            dividend_mag <= 8'd0;
            divisor_mag  <= 8'd0;
            running      <= 1'b0;
            count        <= 4'd0;
            res_valid    <= 1'b0;
            result_reg   <= 16'd0;
            quotient_corr<= 8'd0;
            remainder_corr<=8'd0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid && divisor != 8'd0) begin
                    // Latch inputs
                    dividend_r <= dividend;
                    divisor_r  <= divisor;
                    // Determine sign and magnitude
                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg  <= divisor[7];
                        dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                        divisor_mag  <= divisor[7] ? (~divisor + 8'd1)  : divisor;
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg  <= 1'b0;
                        dividend_mag <= dividend;
                        divisor_mag  <= divisor;
                    end
                    // Initialize shift register: remainder=0, quotient=dividend_mag
                    // Shift left one bit to prepare for division cycle
                    // SR = {remainder[8:0], quotient[7:0]} = {9'b0, dividend_mag}
                    // We set remainder 9 bits to zero initially
                    SR <= {9'd0, dividend_mag};
                    count <= 4'd0;
                    running <= 1'b1;
                end
            end else begin
                // Running division cycles
                // Shift left SR by 1
                // Compute subtraction of divisor_mag from remainder portion
                // If no borrow, keep subtraction and set quotient bit to 1; else restore remainder and set quotient bit to 0

                // Prepare shifted SR: shift left by 1 bit
                // SR[16:0] = {remainder[8:0], quotient[7:0]}
                // After shift left by 1: new remainder = (remainder<<1) + quotient[7]
                // Implemented by SR = {SR[15:0], 1'b0} before subtracting divisor

                // Compute tentative new remainder after shift
                // remainder_next = {SR[16:8], SR[7]} << 1 but since we do shift left by 1 on SR, remainder portion is SR[16:8]

                // Compute shifted SR
                // To avoid registers inside procedural block, do this with temporary variables in combinational outside

                // We do the following steps:
                // 1) Shift SR left by 1: shifted_SR = {SR[15:0], 1'b0};
                // 2) Subtract divisor_mag from shifted_SR[16:8] (new remainder)
                // 3) If subtraction no borrow, SR = {subtraction_result, shifted_SR[7:1], 1'b1}
                //    Else, SR = {shifted_SR[16:8], shifted_SR[7:1], 1'b0}
                // 4) Increment count
                // 5) If count == 8, stop running and compute final results

                reg [16:0] shifted_SR;
                reg [8:0] sub_res;
                reg borrow_sub;
                reg [16:0] SR_next;

                shifted_SR = {SR[15:0], 1'b0};
                sub_res = shifted_SR[16:8] - divisor_ext;
                borrow_sub = sub_res[8];

                if (!borrow_sub) begin
                    // No borrow: remainder updated to sub_res, quotient LSB set to 1
                    SR_next = {sub_res, shifted_SR[7:1], 1'b1};
                end else begin
                    // Borrow: restore remainder, quotient LSB set to 0
                    SR_next = {shifted_SR[16:8], shifted_SR[7:1], 1'b0};
                end

                SR <= SR_next;

                count <= count + 1'b1;

                if (count == 4'd7) begin
                    // Division complete at next clock cycle
                    running <= 1'b0;

                    // Extract raw quotient and remainder for sign correction:
                    // remainder is upper 9 bits of SR_next but only 8 bits are output
                    // We take bits [16:9] for 8-bit remainder (discard LSB of remainder)
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = SR_next[7:0];
                    raw_remainder = SR_next[16:9];

                    // Correct quotient sign
                    if (quotient_neg)
                        quotient_corr <= (~raw_quotient) + 8'd1;
                    else
                        quotient_corr <= raw_quotient;

                    // Correct remainder sign
                    if (remainder_neg)
                        remainder_corr <= (~raw_remainder) + 8'd1;
                    else
                        remainder_corr <= raw_remainder;

                    result_reg <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;
                end
            end

            // Clear res_valid when new opn_valid is detected again or when reset handled above
            if (res_valid && opn_valid && !running)
                res_valid <= 1'b0;
        end
    end

endmodule