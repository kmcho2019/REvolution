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

    // Temporary variables for combinational calculations (declare here)
    reg [16:0] SR_shifted;
    reg [8:0] remainder_part;
    reg [9:0] sub_res;
    reg sub_borrow;
    reg [8:0] remainder_next;
    reg quotient_bit;

    wire [7:0] quotient_unsigned;
    wire [7:0] remainder_unsigned;

    // Assign quotient and remainder slices from SR
    assign quotient_unsigned = SR[7:0];
    assign remainder_unsigned = SR[16:9];

    // Combinational subtraction: remainder_part - divisor_abs
    always @(*) begin
        remainder_part = SR_shifted[16:8];
        {sub_borrow, sub_res} = {1'b0, remainder_part} - {1'b0, divisor_abs};

        if (~sub_borrow) begin
            remainder_next = sub_res[8:0];
            quotient_bit = 1'b1;
        end else begin
            remainder_next = remainder_part;
            quotient_bit = 1'b0;
        end
    end

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

                    dividend_abs_ext <= ((dividend[7] ? (~dividend + 1) : dividend) << 8);
                    divisor_abs <= divisor[7] ? (~divisor + 1) : divisor;

                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg <= 1'b0;
                    sign_quotient <= 1'b0;
                    sign_remainder <= 1'b0;

                    dividend_abs_ext <= dividend << 8;
                    divisor_abs <= divisor;
                end

                // Initialize SR: remainder upper 9 bits are dividend_abs_ext[16:8], quotient zeros
                SR <= {dividend_abs_ext[15:7], 8'd0};

                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Shift left SR by 1 bit
                SR_shifted = {SR[15:0], 1'b0};

                // Subtract divisor_abs from remainder (upper 9 bits after shift)
                // Result in always @(*) block

                // Update SR with new remainder and quotient bit accordingly
                SR <= {remainder_next, SR_shifted[7:1], quotient_bit};

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Division complete after 8 cycles (cnt from 0 to 7)
                    working <= 1'b0;
                    res_valid <= 1'b1;

                    // Apply sign corrections on quotient and remainder after this clock edge
                    // Because SR just updated, wait for next clock cycle to apply sign correction

                    // So create corrected quotient and remainder registers
                end
            end else if (res_valid) begin
                // Apply sign correction once result is valid and working finished
                reg [7:0] quotient_signed;
                reg [7:0] remainder_signed;

                quotient_signed = quotient_unsigned;
                remainder_signed = remainder_unsigned;

                if (sign && sign_quotient) begin
                    quotient_signed = (~quotient_unsigned + 1);
                end

                if (sign && sign_remainder) begin
                    remainder_signed = (~remainder_unsigned + 1);
                end

                result <= {remainder_signed, quotient_signed};
            end

            // Clear res_valid on new opn_valid request when result valid
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule