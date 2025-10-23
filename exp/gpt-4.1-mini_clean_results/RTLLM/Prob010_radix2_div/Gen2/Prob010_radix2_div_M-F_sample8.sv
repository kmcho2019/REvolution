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

    // Internal registers and wires
    reg [16:0] SR;              // Shift register: upper 9 bits remainder, lower 8 bits quotient area
    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext; // dividend_abs shifted left by 8 bits
    reg [3:0] cnt;
    reg working;

    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    // Temporary registers for division iteration
    reg [16:0] SR_shifted;

    wire [8:0] remainder_part_shifted = SR_shifted[16:8];

    // Subtraction: remainder_part_shifted - divisor_abs
    wire [9:0] sub_res;    // 10 bits to detect borrow
    wire sub_borrow;

    assign sub_res = {1'b0, remainder_part_shifted} - {1'b0, divisor_abs};
    assign sub_borrow = sub_res[9];

    reg [8:0] remainder_next;
    reg quotient_bit;

    // Division start and iterative process
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

            // Temporary registers reset
            SR_shifted <= 17'd0;
            remainder_next <= 9'd0;
            quotient_bit <= 1'b0;
        end else begin
            if (opn_valid && !working && !res_valid) begin
                // Start new division operation
                // Calculate absolute values and signs if signed
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];

                    dividend_abs_ext <= ((dividend[7]) ? ((~dividend + 1) & 8'hFF) : dividend) << 8;
                    divisor_abs <= (divisor[7]) ? (~divisor + 1) : divisor;

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

                // Initialize SR:
                // remainder: upper 9 bits from dividend_abs_ext[15:7], quotient zero
                // Because dividend_abs_ext is 16 bits, dividend_abs_ext[15:7] is 9 bits, assigned to upper 9 bits of SR
                // quotient bits (7:0) zero
                SR <= {dividend_abs_ext[15:7], 8'd0};

                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Shift SR left by 1 inserting 0 at LSB
                SR_shifted <= {SR[15:0], 1'b0};

                // Wait one cycle to use SR_shifted for subtraction & update
                // So here SR remains old value, SR_shifted saved for combinational calculation below

                // On next clock, update SR based on subtraction result
                // cnt increments below
                cnt <= cnt + 1'b1;
            end

            if (working) begin
                // Update remainder_next and quotient_bit combinationally based on subtraction result
                if (~sub_borrow) begin
                    // remainder >= divisor_abs after subtraction
                    remainder_next <= sub_res[8:0];
                    quotient_bit <= 1'b1;
                end else begin
                    // remainder < divisor_abs, no subtraction
                    remainder_next <= remainder_part_shifted;
                    quotient_bit <= 1'b0;
                end

                // Update SR after subtraction decision:
                // SR = {remainder_next, SR_shifted[7:1], quotient_bit}
                SR <= {remainder_next, SR_shifted[7:1], quotient_bit};

                // Check if division done after updating SR
                if (cnt == 4'd8) begin
                    // Division complete
                    working <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder before sign correction
                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned = SR[16:9]; // upper 8 bits as remainder

                    // Correct quotient sign if signed division
                    if (sign && sign_quotient) begin
                        quotient_unsigned = (~quotient_unsigned + 1'b1);
                    end

                    // Correct remainder sign if signed division
                    if (sign && sign_remainder) begin
                        remainder_unsigned = (~remainder_unsigned + 1'b1);
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