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

// FSM states
localparam IDLE = 1'b0;
localparam RUN  = 1'b1;

reg state;
reg [3:0] cnt;               // counts from 1 to 8 (division steps)

reg dividend_neg, divisor_neg;
reg quotient_neg, remainder_neg;

reg [7:0] dividend_abs;
reg [7:0] divisor_abs;

// Shift register SR: [16:8] partial remainder (9 bits), [7:0] quotient (8 bits)
reg [16:0] SR;

// Signed 10-bit partial remainder for calculation (9 bits + 1 bit MSB extension)
reg signed [9:0] partial_remainder_10;
reg signed [9:0] divisor_10;

// Next SR value combinational signals
reg signed [9:0] pr_after_op;
reg next_qbit;
reg [16:0] SR_next;

// Helper functions
function [7:0] abs8;
    input [7:0] val;
    input       is_signed;
    begin
        if (is_signed && val[7])
            abs8 = (~val) + 1'b1;
        else
            abs8 = val;
    end
endfunction

function [7:0] apply_sign8;
    input [7:0] val;
    input       negate;
    begin
        apply_sign8 = negate ? (~val + 1'b1) : val;
    end
endfunction

always @(*) begin
    // Extract partial remainder from SR for computation
    // Partial remainder is 9 bits signed: SR[16:8]
    // Extend to 10-bit signed with zero MSB (for sign extension)
    partial_remainder_10 = {SR[16], SR[16:8]}; // sign-extend 9 bits to 10 bits
    divisor_10 = {2'b00, divisor_abs}; // zero-extend divisor_abs to 10 bits
    
    // Shift partial remainder left by 1, including next quotient bit placeholder:
    // The quotient bit to shift in will be decided after subtraction/addition.
    // Actually, shift partial remainder left by 1 bit:
    // partial_remainder_10 << 1, then subtract/add divisor

    // We'll calculate candidate partial remainder shifted left by 1:
    // partial_remainder_10<<1 is 10 bits shifted left by 1 = 11 bits, so keep 10 bits with truncation:
    // Instead, shift partial remainder and add the current quotient MSB before shift:
    // We simulate shifting SR left by 1: quotient bits shift left, partial remainder shifts left:
    // The next partial remainder is (partial_remainder_10 << 1) + next quotient bit (to be set below)

    // Here, the current quotient MSB is SR[7].
    // The multiplication of the combined bits can be simplified by doing:
    // partial_remainder_shifted = (partial_remainder_10 << 1) | SR[7];
    // But since quotient bits are lower bits, quotient MSB is inserted as LSB of partial remainder shift.
    // However, per algorithm, we shift partial remainder left by 1 bit (multiply by 2)
    // then subtract or add divisor_abs depending on sign.
    // The quotient bit for this iteration is set to 1 if result non-negative; else 0.

    // Shift left by 1, discard lowest bit, quotient bit will be new LSB of quotient.

    // So:
    // shifted partial remainder with quotient MSB inserted as LSB before operation:
    // Partial remainder (9 bits) + quotient MSB (1 bit) = 10 bits
    // => partial_remainder_10 = {partial_remainder_9bits, quotient_msb}
    // Then shift left by 1:
    // partial_remainder_shifted = (partial_remainder_10 << 1);

    // Let's implement consistent with algorithm:
    // partial_remainder_with_qbit = {SR[16:8], SR[7]} (10 bits)
    // partial_remainder_shifted = partial_remainder_with_qbit << 1;

    // Then subtract or add divisor_abs depending on sign.

    // Compose partial remainder with quotient MSB:
    {pr_after_op, next_qbit} = 10'd0; // default init

    reg signed [10:0] pr_temp_shifted; // temp 11-bit to hold shift result

    pr_temp_shifted = ({SR[16:8], SR[7]}) << 1; // 10 bits <<1 = 11 bits

    if (pr_temp_shifted[10] == 1'b0) begin
        // non-negative
        pr_temp_shifted = pr_temp_shifted - {1'b0, divisor_10}; // 11 bit - 10 bit = 11 bit
        next_qbit = 1'b1;
    end else begin
        // negative
        pr_temp_shifted = pr_temp_shifted + {1'b0, divisor_10};
        next_qbit = 1'b0;
    end

    // pr_temp_shifted is 11-bit signed result, take upper 10 bits as pr_after_op:
    pr_after_op = pr_temp_shifted[10:1];

    // Compose next SR:
    // New partial remainder: pr_after_op (10 bits) but SR has 9 bits partial remainder [16:8]
    // Take lower 9 bits of pr_after_op (drop MSB):
    // But sign bit of pr_after_op is pr_after_op[9]
    // Need to assign SR[16:8] = pr_after_op[9:1], dropping LSB (bit 0)
    // Quotient shifts left by 1 bit, insert next_qbit at LSB:
    // SR[7:0] = (SR[6:0] << 1) | next_qbit

    // To align with original 9 bits partial remainder:
    // SR[16:8] <= pr_after_op[9:1];
    // Quotient part:
    // SR[7:0] <= {SR[6:0], next_qbit};

    SR_next = {pr_after_op[9:1], SR[6:0], next_qbit};
end

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
            if (res_valid && !opn_valid) begin
                // Clear res_valid only when new op not requested
                res_valid <= 1'b0;
            end

            if (opn_valid && !res_valid) begin
                dividend_neg <= (sign && dividend[7]);
                divisor_neg <= (sign && divisor[7]);
                dividend_abs <= abs8(dividend, sign);
                divisor_abs <= abs8(divisor, sign);

                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg <= (sign && dividend[7]);

                // Initialize SR:
                // partial remainder = dividend_abs shifted left by 1 (9 bits)
                // quotient = 0
                SR <= {dividend_abs, 1'b0, 8'd0};
                cnt <= 4'd1;
                state <= RUN;
            end else begin
                cnt <= 4'd0;
            end
        end

        RUN: begin
            SR <= SR_next;
            if (cnt == 4'd8) begin
                // Correction of remainder if negative
                // If pr_after_op negative (pr_after_op[9]==1), add divisor_abs
                reg signed [9:0] rem_corr;
                rem_corr = pr_after_op;
                if (pr_after_op[9] == 1'b1) begin
                    rem_corr = pr_after_op + divisor_10;
                end

                // Apply sign corrections
                // Quotient is SR_next[7:0] after last update
                // Remainder is rem_corr[8:1] (9 bits)
                reg [7:0] quotient_tmp;
                reg [7:0] remainder_tmp;

                quotient_tmp = apply_sign8(SR_next[7:0], quotient_neg);
                remainder_tmp = apply_sign8(rem_corr[8:1], remainder_neg);

                result <= {remainder_tmp, quotient_tmp};
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