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
reg [3:0] cnt;               // counts division steps from 1 to 8

reg dividend_neg, divisor_neg;
reg quotient_neg, remainder_neg;

reg [7:0] dividend_abs;
reg [7:0] divisor_abs;

// Shift register SR: 17 bits = [16:8] partial remainder (9 bits signed), [7:0] quotient
reg [16:0] SR;

// Intermediate signals for combinational calculation
// pr_ext/pr_next: signed extended partial remainder (10 bits to cover shifts and sign)
reg signed [9:0] pr_ext;
reg signed [9:0] pr_next;
reg signed [10:0] pr_temp_shifted; // 11 bits to hold shifted value with sign

reg next_qbit;
reg [16:0] SR_next;

// Functions for signed abs and signed apply_sign
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
        if (negate)
            apply_sign8 = (~val) + 1'b1;
        else
            apply_sign8 = val;
    end
endfunction

// Combinational calculation of next SR value based on current SR and divisor_abs
always @(*) begin
    // Extract partial remainder (9 bits signed) from SR[16:8], sign-extended to 10 bits
    pr_ext = {SR[16], SR[16:8]}; // 9 bits -> 10 bits with sign extension

    // Compose a 10-bit value concatenating partial remainder and current quotient MSB (SR[7])
    // This simulates the shift left by 1 with quotient MSB inserted before subtraction/addition
    pr_temp_shifted = ({pr_ext, SR[7]} << 1); // 10 bits concatenated shifted left by 1 = 11 bits

    // Divisor extended to 11 bits for arithmetic (shifted by one zero MSB)
    // divisor_abs is 8 bits, zero-extend to 11 bits for alignment
    // The top bit in pr_temp_shifted is bit 10

    if (pr_temp_shifted[10] == 1'b0) begin
        // partial remainder non-negative, subtract divisor
        pr_temp_shifted = pr_temp_shifted - {3'b0, divisor_abs};
        next_qbit = 1'b1;
    end else begin
        // partial remainder negative, add divisor
        pr_temp_shifted = pr_temp_shifted + {3'b0, divisor_abs};
        next_qbit = 1'b0;
    end

    // Extract next partial remainder: bits [10:1] (10 bits signed)
    pr_next = pr_temp_shifted[10:1];

    // Compose next SR: partial remainder [16:8] = pr_next[9:1] (9 bits)
    // quotient [7:0] = left shift previous quotient [6:0] plus next_qbit inserted LSB
    SR_next = {pr_next[9:1], SR[6:0], next_qbit};
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
                // Clear res_valid only when no new operation requested
                res_valid <= 1'b0;
            end

            if (opn_valid && !res_valid) begin
                dividend_neg <= (sign && dividend[7]);
                divisor_neg <= (sign && divisor[7]);

                dividend_abs <= abs8(dividend, sign);
                divisor_abs <= abs8(divisor, sign);

                quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                remainder_neg <= (sign && dividend[7]);

                // Initialize SR: partial remainder = dividend_abs shifted left by 1 (9 bits), quotient=0
                // SR[16:8] = dividend_abs (8 bits) plus one zero bit as LSB
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
                // Division complete, apply final remainder correction if needed

                // pr_next holds current partial remainder (10 bits), use it here
                // If pr_next negative, add divisor_abs
                if (pr_next[9] == 1'b1) begin
                    pr_next <= pr_next + {2'b00, divisor_abs}; // 10 bits = 2 MSB zero + divisor_abs
                end

                // Compose final quotient and remainder with sign applied
                result[7:0] <= apply_sign8(SR_next[7:0], quotient_neg);
                // Take 8 bits remainder from pr_next[8:1] (bits 8 down to 1)
                result[15:8] <= apply_sign8(pr_next[8:1], remainder_neg);

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