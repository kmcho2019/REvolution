module radix2_div(
    input             clk,
    input             rst,
    input             sign,          // 1 for signed division, 0 for unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    input             res_ready,     // Added to handshake result consumption
    output reg        res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;              // Shift register: {9-bit remainder, 8-bit quotient}
    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_shifted; // dividend_abs shifted left by 8 bits
    reg [3:0] cnt;
    reg busy;

    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    // Temporary variables for subtraction
    reg [8:0] remainder;
    reg [8:0] sub_result;
    reg sub_borrow;

    // Registers for sign corrections
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Absolute value function for 8-bit signed numbers
    function [7:0] abs_8;
        input [7:0] val;
        begin
            abs_8 = val[7] ? (~val + 1) : val;
        end
    endfunction

    // Main process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs_shifted <= 16'd0;
            cnt <= 4'd0;
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            if (opn_valid && !busy && !res_valid && divisor != 8'd0) begin
                // Start division operation
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];
                    divisor_abs <= abs_8(divisor);
                    // Compute absolute dividend and shift left by 8 bits
                    dividend_abs_shifted <= {8'd0, abs_8(dividend)} << 8;
                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg <= 1'b0;
                    divisor_abs <= divisor;
                    dividend_abs_shifted <= {8'd0, dividend} << 8;
                    sign_quotient <= 1'b0;
                    sign_remainder <= 1'b0;
                end
                // Initialize shift register: remainder part = dividend_abs_shifted[15:7] (9 bits), quotient = 0
                SR <= {dividend_abs_shifted[15:7], 8'd0};
                cnt <= 4'd0;
                busy <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (busy) begin
                // Extract remainder (upper 9 bits)
                remainder = SR[16:8];

                // Subtract divisor_abs from remainder
                {sub_borrow, sub_result} = {1'b0, remainder} - {1'b0, divisor_abs};

                // Shift SR left by 1 (tentative update)
                SR <= {SR[15:0], 1'b0};

                // Update SR with remainder and quotient bit according to subtraction
                if (sub_borrow == 0) begin
                    // Update remainder and set quotient bit = 1
                    SR <= {sub_result, SR[7:1], 1'b1};
                end else begin
                    // Keep remainder and set quotient bit = 0
                    SR <= {remainder, SR[7:1], 1'b0};
                end

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Division complete
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract raw quotient and remainder
                    quotient_raw = SR[7:0];
                    remainder_raw = SR[16:9]; // 8 bits remainder is bits 16 down to 9

                    // Apply sign corrections if signed division
                    if (sign) begin
                        // Correct quotient sign
                        if (sign_quotient)
                            quotient_final = (~quotient_raw + 1);
                        else
                            quotient_final = quotient_raw;

                        // Correct remainder sign
                        if (sign_remainder)
                            remainder_final = (~remainder_raw + 1);
                        else
                            remainder_final = remainder_raw;
                    end else begin
                        quotient_final = quotient_raw;
                        remainder_final = remainder_raw;
                    end

                    result <= {remainder_final, quotient_final};
                end
            end

            // Clear res_valid when result consumed by testbench via res_ready
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end

            // If divisor is zero and opn_valid, output zero result immediately and assert res_valid
            if (opn_valid && divisor == 8'd0 && !busy && !res_valid) begin
                busy <= 1'b0;
                res_valid <= 1'b1;
                result <= 16'd0;
            end
        end
    end

endmodule