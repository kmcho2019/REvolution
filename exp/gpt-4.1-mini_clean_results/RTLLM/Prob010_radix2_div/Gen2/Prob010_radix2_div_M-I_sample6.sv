module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);
    // Internal signals and registers

    reg busy; // indicates division in progress

    // Signedness and absolute values
    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit remainder register (9 bits remainder upper + 8 bits quotient shifted in)
    reg [16:0] remainder_reg;

    // 8-bit quotient register
    reg [7:0] quotient_reg;

    // Iteration counter from 0 to 7 (8 cycles)
    reg [3:0] count;

    // Subtraction result (9 bits): upper 9 bits of shifted remainder - divisor_abs
    reg [8:0] sub_res;

    wire sub_non_negative = ~sub_res[8]; // MSB 0 means non-negative result

    // Wires for absolute values and signs computed combinationally at start
    wire [7:0] dividend_abs_w = sign && dividend[7] ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_w  = sign && divisor[7]  ? (~divisor + 8'd1)  : divisor;
    wire dividend_neg_w = sign ? dividend[7] : 1'b0;
    wire divisor_neg_w  = sign ? divisor[7]  : 1'b0;

    // Final quotient and remainder registers declared at module scope
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            remainder_reg <= 17'b0;
            quotient_reg <= 8'b0;
            count <= 4'd0;
            sub_res <= 9'd0;
            final_quotient <= 8'b0;
            final_remainder <= 8'b0;
        end else begin
            if (!busy && opn_valid) begin
                // Start division operation
                dividend_abs <= dividend_abs_w;
                divisor_abs <= divisor_abs_w;
                dividend_neg <= dividend_neg_w;
                divisor_neg <= divisor_neg_w;
                sign_quotient <= dividend_neg_w ^ divisor_neg_w;
                sign_remainder <= dividend_neg_w;
                // Initialize remainder_reg: upper 9 bits zero, lower 8 bits = dividend_abs
                remainder_reg <= {9'd0, dividend_abs_w};
                quotient_reg <= 8'd0;
                count <= 4'd0;
                busy <= 1'b1;
                res_valid <= 1'b0;
            end else if (busy) begin
                // Perform one iteration of radix-2 division

                // Step 1: shift remainder_reg left by 1
                // A temporary shifted value
                reg [16:0] shifted;
                shifted = remainder_reg << 1;

                // Step 2: subtraction: upper 9 bits of shifted - divisor_abs (zero-extended)
                sub_res = {1'b0, shifted[16:8]} - {1'b0, divisor_abs};

                if (sub_non_negative) begin
                    // Subtraction >= 0: update remainder_reg upper 9 bits with sub_res
                    // quotient bit = 1
                    remainder_reg <= {sub_res[8:0], shifted[7:0]};
                    quotient_reg <= {quotient_reg[6:0], 1'b1};
                end else begin
                    // Subtraction < 0: remainder_reg remains shifted (no subtraction)
                    // quotient bit = 0
                    remainder_reg <= shifted;
                    quotient_reg <= {quotient_reg[6:0], 1'b0};
                end

                count <= count + 4'd1;

                if (count == 4'd7) begin
                    // Last iteration done, finalize result
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract remainder from upper 9 bits of remainder_reg:
                    // remainder_reg[16:8] is 9 bits remainder (includes sign bit)
                    // We need only 8 bits remainder, assume remainder is unsigned or sign-corrected below
                    // Just take bits [16:9] as remainder (8 bits)
                    final_remainder <= remainder_reg[16:9];

                    // Sign correction on quotient
                    if (sign) begin
                        // Quotient sign correction
                        if (sign_quotient)
                            final_quotient <= (~quotient_reg + 8'd1);
                        else
                            final_quotient <= quotient_reg;

                        // Remainder sign correction (remainder always same sign as dividend)
                        if (sign_remainder)
                            final_remainder <= (~final_remainder + 8'd1);
                        // else final_remainder remains as is
                    end else begin
                        final_quotient <= quotient_reg;
                    end

                    // Assign final result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {final_remainder, final_quotient};
                end
            end else begin
                // Idle state, clear res_valid on new operation request if previously set
                if (res_valid && opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule