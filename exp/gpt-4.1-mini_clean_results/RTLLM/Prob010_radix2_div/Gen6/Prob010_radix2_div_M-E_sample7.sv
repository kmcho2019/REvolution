module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_sign, divisor_sign;
    reg       quotient_sign, remainder_sign;

    // Shift register:
    // [17:9] = 9-bit remainder (includes one extra bit for subtraction sign)
    // [8:1]  = 8-bit quotient
    // [0]    = next dividend bit to be shifted in (implicitly managed)
    reg [17:0] shift_reg;

    reg [3:0] cycle_cnt; // count cycles from 0 to 8

    // Wires for subtraction
    wire signed [9:0] rem_sub_div; // 10 bits signed for remainder - divisor_abs
    wire [8:0] remainder = shift_reg[17:9]; // 9-bit remainder (MSB is sign bit for subtraction)

    // Subtraction operation: remainder - divisor_abs
    assign rem_sub_div = {1'b0, remainder} - {1'b0, divisor_abs};

    // Absolute value function for 8-bit input
    function [7:0] abs_8;
        input [7:0] in;
        begin
            if (sign && in[7])
                abs_8 = (~in) + 8'd1;
            else
                abs_8 = in;
        end
    endfunction

    // Two's complement 8-bit negation
    function [7:0] neg_8;
        input [7:0] in;
        begin
            neg_8 = (~in) + 8'd1;
        end
    endfunction

    // Sign adjustment for 8-bit value
    function [7:0] sign_adjust;
        input [7:0] val;
        input       sign_flag;
        begin
            if (sign_flag)
                sign_adjust = neg_8(val);
            else
                sign_adjust = val;
        end
    endfunction

    // FSM Sequential logic and main algorithm
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'b0;
            shift_reg     <= 18'b0;
            cycle_cnt     <= 4'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs
                        dividend_sign <= sign ? dividend[7] : 1'b0;
                        divisor_sign  <= sign ? divisor[7]  : 1'b0;
                        quotient_sign <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= sign ? dividend[7] : 1'b0;

                        // Calculate absolute values
                        dividend_abs <= abs_8(dividend);
                        divisor_abs  <= abs_8(divisor);

                        // Initialize shift_reg:
                        // remainder (9 bits) = 0 initially
                        // quotient (8 bits) = 0
                        // Left shift dividend_abs one bit left for initial shifting: 
                        // Actually, place dividend_abs in lower bits after remainder zeroed,
                        // but since we shift left each cycle, we initialize remainder with zero, quotient zero, and dividend_abs loaded after shift-in
                        shift_reg <= {9'd0, dividend_abs, 1'b0}; 
                        // The above places:
                        // remainder = 9'd0 (bits 17:9)
                        // quotient = dividend_abs (bits 8:1)
                        // LSB bit 0 initialized zero
                        // However, we want to start with dividend_abs loaded in the low bits to shift into remainder progressively.
                        // Actually, to match standard algorithm, the dividend bits are shifted in MSB first.
                        // Thus, better approach: load dividend_abs in lower 8 bits, remainder zero.
                        shift_reg <= {9'd0, dividend_abs};

                        cycle_cnt <= 0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: output max quotient and dividend as remainder at DONE
                        // Just increment count to finish
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end else if (cycle_cnt < 8) begin
                        // Shift left shift_reg by 1 bit
                        // shift_reg[17:0] <<= 1, next dividend bit shifted into remainder LSB
                        // Then subtract divisor_abs from remainder and decide quotient bit
                        // Actually, the subtraction is remainder - divisor_abs with 9-bit remainder

                        // Extract remainder before shifting for subtraction
                        // But subtraction already assigned by rem_sub_div = remainder - divisor_abs

                        if (rem_sub_div[9] == 1'b0) begin
                            // subtraction result non-negative -> update remainder and set quotient LSB = 1
                            // shift_reg next:
                            // remainder = rem_sub_div[8:0]
                            // quotient shifted left by 1 + 1

                            shift_reg <= {rem_sub_div[8:0], shift_reg[8:1], 1'b1};
                        end else begin
                            // subtraction negative -> restore remainder and set quotient LSB = 0
                            // shift_reg next:
                            // remainder unchanged
                            // quotient shifted left by 1 + 0
                            shift_reg <= {remainder, shift_reg[8:1], 1'b0};
                        end

                        cycle_cnt <= cycle_cnt + 1'b1;
                    end else begin
                        // Done with division cycles
                        cycle_cnt <= cycle_cnt;
                    end
                end

                DONE: begin
                    // res_valid asserted until next opn_valid
                    res_valid <= 1'b1;
                end
            endcase

            // At transition to DONE, compute final result with sign correction
            if (state == DIVIDE && cycle_cnt == 8) begin
                // Extract quotient and remainder from shift_reg
                // remainder: upper 9 bits [17:9], take bits [16:9] as 8-bit remainder (discard sign bit)
                // quotient: lower 8 bits [8:1]
                // Note: remainder is 9 bits, sign bit at [17], but after algorithm remainder >=0 always because restoring division.

                reg [7:0] rem_raw, quo_raw;

                rem_raw = shift_reg[16:9];
                quo_raw = shift_reg[8:1];

                if (sign) begin
                    // Fix signs: quotient sign
                    quo_raw = quotient_sign ? (~quo_raw + 8'd1) : quo_raw;
                    // remainder sign
                    rem_raw = remainder_sign ? (~rem_raw + 8'd1) : rem_raw;
                end

                result <= {rem_raw, quo_raw};
            end
        end
    end

    // FSM Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end

            DIVIDE: begin
                if (cycle_cnt == 8)
                    next_state = DONE;
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule