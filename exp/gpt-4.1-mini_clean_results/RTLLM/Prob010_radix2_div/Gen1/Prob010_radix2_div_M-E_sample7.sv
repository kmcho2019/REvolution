module radix2_div(
    input              clk,
    input              rst,
    input              sign,         // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    // Internal signals and registers
    reg [16:0] SR;              // Shift register: upper 9 bits remainder, lower 8 bits quotient area
    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext; // dividend_abs shifted left by 8 bits
    reg [3:0] cnt;
    reg working;

    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    wire [8:0] sub_res;
    wire sub_borrow;

    // Extract remainder part from SR upper 9 bits (bits 16:8)
    wire [8:0] remainder_part = SR[16:8];
    // Quotient part is in SR lower 8 bits (7:0)

    // Prepare subtraction: remainder_part - divisor_abs
    assign {sub_borrow, sub_res} = {1'b0, remainder_part} - {1'b0, divisor_abs};

    // States and control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs_ext <= 16'd0;
            cnt <= 4'd0;
            working <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            if (opn_valid && !working && !res_valid) begin
                // Start new division operation
                // Calculate absolute values and signs if signed
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];

                    dividend_abs_ext <= {{8{1'b0}}, (dividend[7] ? (~dividend + 1) : dividend)} << 8; // Shift left 8 bits
                    divisor_abs <= divisor[7] ? (~divisor + 1) : divisor;

                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg <= 1'b0;
                    sign_quotient <= 1'b0;
                    sign_remainder <= 1'b0;

                    dividend_abs_ext <= {8'd0, dividend} << 8;
                    divisor_abs <= divisor;
                end

                // Initialize SR: remainder in upper 9 bits (start with dividend_abs_ext[15:7] zero extended to 9 bits)
                // We'll start remainder with dividend_abs_ext[16:8], quotient is 0 initially
                // But dividend_abs_ext is 16 bits; assign bits 16:8 remainder, quotient zeros
                SR <= {dividend_abs_ext[15:7], 8'd0};

                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Iterative division cycles, 8 times
                // Shift left SR by 1 bit: 
                // Because SR is 17 bits, shift left by 1
                // Insert 0 at LSB first, then decide quotient bit based on subtraction

                // Shift left by 1
                SR <= {SR[15:0], 1'b0};

                // After shift, try to subtract divisor_abs from upper 9 bits (bits 16:8)
                // If no borrow (meaning remainder >= divisor_abs), set quotient bit (LSB of SR) to 1 and update remainder to sub_res
                // Else keep remainder as before and quotient bit 0

                // Wait one cycle to evaluate sub_borrow/sub_res due to SR update - so use combinational calculation

                // To simplify, perform subtraction before shift and update SR accordingly

                // So implement in sequential process below:

                // For single-cycle behavior, move subtraction and update after shift
                // But to avoid combinational complexity, we can re-organize logic into a two-stage FSM or use temporary variables

                // We'll do the subtraction after shift, and conditionally update SR on next clock

                // Since we are in sequential block, implement as:
                // 1) shift left by 1 with 0
                // 2) subtract divisor_abs from upper 9 bits of SR
                // 3) if remainder >= divisor_abs, update remainder and set quotient bit = 1
                //    else revert remainder and quotient bit = 0 (LSB stays 0 due to shift)

                // Implement this with temp registers

            end

            if (working) begin
                // Use temp variables in combinational logic to update SR accordingly
                // Since SR updated on posedge, use temporary registers and update SR in this block

                reg [16:0] SR_shifted;
                reg [8:0] remainder_next;
                reg quotient_bit;

                SR_shifted = {SR[15:0], 1'b0};

                // Subtract divisor_abs from remainder part
                reg [8:0] rem_after_shift;
                rem_after_shift = SR_shifted[16:8];

                reg [9:0] sub_res_tmp;
                reg sub_borrow_tmp;
                sub_res_tmp = {1'b0, rem_after_shift} - {1'b0, divisor_abs};
                sub_borrow_tmp = sub_res_tmp[9];

                if (~sub_borrow_tmp) begin
                    // remainder >= divisor_abs after subtraction
                    remainder_next = sub_res_tmp[8:0];
                    quotient_bit = 1'b1;
                end else begin
                    // remainder < divisor_abs, do not subtract
                    remainder_next = rem_after_shift;
                    quotient_bit = 1'b0;
                end

                // Update SR with new remainder and quotient bit (LSB)
                SR <= {remainder_next, SR_shifted[7:1], quotient_bit};

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Division complete at next cycle
                    working <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign corrections on quotient and remainder

                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned = SR[16:9]; // remainder in bits 16 down to 9 (8 bits)

                    // Correct quotient sign
                    if (sign && sign_quotient) begin
                        quotient_unsigned = (~quotient_unsigned + 1);
                    end

                    // Correct remainder sign
                    if (sign && sign_remainder) begin
                        remainder_unsigned = (~remainder_unsigned + 1);
                    end

                    result <= {remainder_unsigned, quotient_unsigned};
                end
            end

            // Clear res_valid on new opn_valid request when result valid
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule