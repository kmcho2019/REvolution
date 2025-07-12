module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,      // start division when high and res_valid is low
    output reg          res_valid,
    output reg  [15:0]  result          // [15:8]: remainder, [7:0]: quotient
);

// States for division control
localparam IDLE = 1'b0;
localparam RUN  = 1'b1;

reg state;
reg [3:0] cnt;               // counts from 1 to 8 (division steps)

// Internal signals for signed operations
reg dividend_neg, divisor_neg;
reg quotient_neg, remainder_neg;

reg [7:0] dividend_abs;
reg [7:0] divisor_abs;

// Shift register holding {partial_remainder[8:0], quotient[7:0]} = 17 bits
reg [16:0] SR;

// Wire to extract partial remainder from SR
wire [8:0] partial_remainder = SR[16:8];

// Wire for next partial remainder calculation (10 bits to hold overflow)
reg signed [9:0] pr_ext;
reg signed [9:0] pr_next;

// Next quotient bit to shift in
reg next_qbit;

// Temporary variables for sign-correction
reg [7:0] quotient_corrected;
reg [7:0] remainder_corrected;

// Helper function for absolute value (signed to unsigned)
function [7:0] abs8;
    input [7:0] in;
    input       is_signed;
    begin
        if (is_signed && in[7] == 1'b1)
            abs8 = (~in + 1'b1);
        else
            abs8 = in;
    end
endfunction

// Helper function to apply sign (two's complement if sign bit set)
function [7:0] apply_sign8;
    input [7:0] in;
    input       negate;
    begin
        apply_sign8 = negate ? (~in + 1'b1) : in;
    end
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 4'd0;
        res_valid <= 1'b0;
        result <= 16'd0;
        SR <= 17'd0;
        dividend_neg <= 1'b0;
        divisor_neg <= 1'b0;
        quotient_neg <= 1'b0;
        remainder_neg <= 1'b0;
        dividend_abs <= 8'd0;
        divisor_abs <= 8'd0;
    end else begin
        case(state)
        IDLE: begin
            res_valid <= 1'b0;    // Clear res_valid in idle
            cnt <= 4'd0;
            if (opn_valid && !res_valid) begin
                // Capture operand signs and absolute values
                dividend_neg <= (sign && dividend[7]);
                divisor_neg <= (sign && divisor[7]);
                dividend_abs <= abs8(dividend, sign);
                divisor_abs <= abs8(divisor, sign);

                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg <= (sign && dividend[7]);

                // Initialize SR with partial remainder = dividend_abs shifted left by 1 (9 bits),
                // quotient = 0 (8 bits)
                // partial remainder[8:1] = dividend_abs[7:0], partial remainder[0] = 0
                // So partial remainder = dividend_abs << 1
                SR <= {dividend_abs, 1'b0, 8'd0};

                cnt <= 4'd1;
                state <= RUN;
            end
        end

        RUN: begin
            // Non-restoring division step:

            // Extend partial remainder to 10-bit signed to allow + and - divisor_abs
            // Shift partial remainder left by 1 bit, shifting in the MSB of quotient (SR[7])
            pr_ext = {partial_remainder[7:0], SR[7], 1'b0}; // 9 bits shifted left 1 + quotient MSB as LSB before shift? 
            // The quotient bits are in SR[7:0], but we should shift the entire SR left by 1:
            // Actually, better to shift SR left by 1 first, then calculate pr_next

            // Let's do a shift-left of SR by 1 first (except partial remainder), then update partial remainder:

            // We'll do combinational inside this block for clarity:
            // Shift SR left by 1: SR << 1
            // After shift, partial remainder = SR[16:8], quotient = SR[7:0]

            // To do this properly, we calculate the candidate partial remainder:

            // We do:
            // pr_ext = {partial_remainder, quotient MSB} << 1
            // partial_remainder = SR[16:8]
            // quotient MSB = SR[7]

            // So:
            pr_ext = {partial_remainder, SR[7]}; // 9 + 1 bits = 10 bits
            pr_ext = pr_ext << 1; // shift left by 1 bit

            // Then apply non-restoring division step:
            // If partial remainder >= 0, subtract divisor_abs; else add divisor_abs
            if (pr_ext[9] == 1'b0) begin
                // non-negative
                pr_next = pr_ext - {2'b00, divisor_abs}; // 10 bits - 10 bits
                next_qbit = 1'b1;
            end else begin
                // negative
                pr_next = pr_ext + {2'b00, divisor_abs};
                next_qbit = 1'b0;
            end

            // Update SR: 
            // New partial remainder = pr_next[9:1] (we drop LSB)
            // Quotient = (SR[6:0] shifted left by 1) + next_qbit
            SR <= {pr_next[9:1], SR[6:0], next_qbit};

            if (cnt == 4'd8) begin
                // Last iteration completed; finalize remainder correction:
                // If partial remainder negative, add divisor back
                if (pr_next[9] == 1'b1) begin
                    SR[16:8] <= pr_next[9:1] + {1'b0, divisor_abs};
                end else begin
                    SR[16:8] <= pr_next[9:1];
                end

                // Apply sign correction
                quotient_corrected <= apply_sign8(SR[7:0], quotient_neg);
                remainder_corrected <= apply_sign8(SR[16:9], remainder_neg);

                // Output result concatenated: remainder upper 8 bits, quotient lower 8 bits
                result <= {remainder_corrected, quotient_corrected};

                res_valid <= 1'b1;
                state <= IDLE;
                cnt <= 4'd0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end

        default: state <= IDLE;

        endcase
    end
end

endmodule