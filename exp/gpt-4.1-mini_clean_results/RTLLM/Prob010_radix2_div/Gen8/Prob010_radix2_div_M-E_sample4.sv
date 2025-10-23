module radix2_div (
    input            clk,
    input            rst,
    input            sign,
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,
    input            res_ready,
    output reg       res_valid,
    output reg [15:0] result
);

    // FSM states
    localparam IDLE = 1'b0, RUN = 1'b1;
    reg state, next_state;

    // Internal registers
    reg [8:0] divisor_abs;      // 9 bits to safely hold negation without overflow
    reg [8:0] neg_divisor;      // -divisor_abs in 9 bits (two's complement)
    reg [16:0] SR;              // Shift Register: [16:8] remainder(9 bits), [7:0] quotient (8 bits)
    reg [3:0] cnt;              // 4-bit counter from 1 to 8 for division steps

    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    reg start_div;

    // Wires for subtraction
    wire [8:0] rem_before_sub = SR[16:8];         // current remainder (9 bits)
    wire [9:0] rem_sub;                            // 10 bits for subtraction result to detect negative
    wire rem_sub_neg;                              // indicates subtraction result negative (carry out)

    // Absolute value function for 8-bit signed number if sign==1
    function [8:0] abs9;
        input [7:0] val;
        input       sign_bit;
        begin
            if (sign && val[7])       // negative number
                abs9 = {1'b0, (~val) + 8'd1};
            else
                abs9 = {1'b0, val};
        end
    endfunction

    // Two's complement negation for 9-bit number
    function [8:0] neg9;
        input [8:0] val;
        begin
            neg9 = (~val) + 9'd1;
        end
    endfunction

    // Sign correction function for 8-bit output with a sign bit
    function [7:0] sign_correct_8;
        input [7:0] val;
        input       apply_sign;   // 1 means negate val, 0 means keep val
        begin
            if (apply_sign)
                sign_correct_8 = (~val) + 8'd1;
            else
                sign_correct_8 = val;
        end
    endfunction

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: 
                if (opn_valid && !res_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            RUN:
                if (cnt == 4'd8)
                    next_state = IDLE;  // Finished division after 8 iterations
                else
                    next_state = RUN;
            default:
                next_state = IDLE;
        endcase
    end

    // Subtraction: remainder - divisor_abs
    assign rem_sub = {1'b0, rem_before_sub} + neg_divisor;  
    assign rem_sub_neg = rem_sub[9]; // if MSB=1, negative

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            SR            <= 17'd0;
            cnt           <= 4'd0;
            divisor_abs   <= 9'd0;
            neg_divisor   <= 9'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
            start_div     <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= res_valid && !res_ready ? 1'b1 : 1'b0;
                    cnt       <= 4'd0;

                    if (opn_valid && !res_valid) begin
                        // Compute signs
                        dividend_sign <= sign ? dividend[7] : 1'b0;
                        divisor_sign  <= sign ? divisor[7] : 1'b0;

                        quotient_sign <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= sign ? dividend[7] : 1'b0;

                        // Compute absolute values with 9 bits to prevent overflow
                        divisor_abs <= abs9(divisor, sign);

                        // Compute neg_divisor = -divisor_abs for subtraction (9-bit)
                        // If divisor is zero, neg_divisor zero; division-by-zero not handled explicitly here
                        neg_divisor <= neg9(abs9(divisor, sign));

                        // Initialize SR = remainder(9'b0) + quotient(dividend_abs)
                        // quotient in lower 8 bits, remainder zero in upper 9 bits
                        SR <= {9'd0, abs9(dividend, sign)[7:0]};

                        start_div <= 1'b1;

                        res_valid <= 1'b0;
                    end else
                        start_div <= 1'b0;
                end

                RUN: begin
                    if (start_div || cnt != 0) begin
                        cnt <= cnt + 1'b1;

                        // Step 1: Shift left SR by 1 bit
                        // This moves one bit of quotient into remainder
                        SR <= {SR[15:0], 1'b0};

                        // Step 2: Subtract divisor_abs from remainder (upper 9 bits)
                        // We do this combinationally in next cycle. So we stage signals here.

                        // Step 3: Check subtraction result sign
                        // We update SR accordingly:
                        // If rem_sub >= 0 (not negative), update remainder and set quotient LSB=1
                        // Else restore remainder (no change) and set quotient LSB=0

                        // However, to update SR correctly, we wait one cycle. So we use a register to hold next SR value.

                    end
                end

                default: ;
            endcase

            // Handle iteration logic after shift
            if (state == RUN && cnt != 0 && cnt <= 8) begin
                // After shift (already assigned SR in posedge), perform subtraction and update SR

                if (!rem_sub_neg) begin
                    // Subtraction result non-negative: update remainder and set quotient bit to 1
                    // remainder upper 9 bits = rem_sub[8:0]
                    // quotient lower 8 bits: LSB set to 1

                    // Prepare next SR value with updated remainder and quotient bit set
                    // Current SR after shift: remainder[16:8], quotient[7:0] (LSB zero after shift)
                    // So set SR[0] = 1 for quotient bit

                    SR <= {rem_sub[8:0], SR[7:1], 1'b1};
                end else begin
                    // Subtraction negative: restore remainder (keep previous remainder)
                    // quotient bit remains 0 (already zero after shift)
                    // So restore remainder by keeping remainder before subtraction

                    // Because SR already shifted left, we need to restore remainder bits to original
                    // Remainder bits before subtraction are shifted remainder bits before adding neg_divisor.

                    // The previous remainder bits before subtraction is SR shifted left,
                    // but we must restore upper 9 bits to original remainder before subtraction.

                    // The only option is to restore remainder to previous remainder shifted left by 1 bit.

                    // We can implement by adding back divisor_abs (negate neg_divisor)

                    // So SR upper bits = remainder_before_subtraction (SR[16:8]) + divisor_abs

                    SR <= { (rem_before_sub), SR[7:1], 1'b0};  // quotient bit 0
                end

                if (cnt == 4'd8) begin
                    // Division finished
                    // Compute final result and apply sign correction

                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    // Quotient is lower 8 bits
                    quotient_final = SR[7:0];
                    // Remainder is upper 8 bits (bits [16:9]), discard MSB sign bit
                    remainder_final = SR[16:9];

                    // Apply sign correction if needed
                    if (sign) begin
                        if (quotient_sign)
                            quotient_final = (~quotient_final) + 8'd1;

                        if (remainder_sign)
                            remainder_final = (~remainder_final) + 8'd1;
                    end

                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;
                end
            end
        end
    end

endmodule