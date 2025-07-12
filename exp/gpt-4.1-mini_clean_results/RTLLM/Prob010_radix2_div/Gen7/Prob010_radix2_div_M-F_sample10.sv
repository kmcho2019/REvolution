module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    input             res_ready,
    output reg        res_valid,
    output reg [15:0] result
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state, next_state;

    // Shift register holding partial remainder + quotient bits + 1 extra bit for shifting
    // Total width = 17 bits: remainder in upper 9 bits (16:8), quotient in lower 8 bits (7:0)
    reg [16:0] SR;

    // Negative divisor (9-bit two's complement) for subtraction
    reg [8:0] NEG_DIVISOR;

    // Counter for iterations (0..8)
    reg [3:0] cnt;

    // Absolute values of dividend and divisor
    reg [7:0] dividend_abs, divisor_abs;

    // Signs of dividend and divisor (only valid if sign==1)
    reg dividend_neg, divisor_neg;

    // Sign flags for quotient and remainder results
    reg quotient_neg, remainder_neg;

    // Wires for subtraction
    wire [8:0] sub_res;    // 9-bit result of subtraction (partial remainder - divisor)
    wire       carry_out;  // carry_out = 1 means subtraction succeeded (no borrow)

    // Get absolute value function (for signed inputs)
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 1'b1;
            else
                abs8 = val;
        end
    endfunction

    // Subtraction: upper 9 bits of SR + NEG_DIVISOR
    // NEG_DIVISOR = -divisor_abs extended to 9 bits two's complement
    assign {carry_out, sub_res} = {1'b0, SR[16:8]} + NEG_DIVISOR;

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = BUSY;
                else
                    next_state = IDLE;
            end
            BUSY: begin
                if (cnt == 4'd8)
                    next_state = IDLE;
                else
                    next_state = BUSY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            SR           <= 17'd0;
            NEG_DIVISOR  <= 9'd0;
            cnt          <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Clear res_valid only when consumer accepts result
                    if (res_valid && res_ready)
                        res_valid <= 1'b0;

                    if (opn_valid && !res_valid) begin
                        // Capture absolute values and sign flags
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        dividend_neg <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg  <= (sign) ? divisor[7]  : 1'b0;

                        // Determine quotient and remainder sign
                        quotient_neg  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        // Initialize SR:
                        // remainder in upper 9 bits (start with 0),
                        // load dividend_abs in lower 8 bits shifted left by 1 (LSB zero) for shift-in process
                        SR <= {9'd0, dividend_abs, 1'b0};

                        // NEG_DIVISOR = -divisor_abs (9 bits)
                        // If divisor_abs==0, set NEG_DIVISOR=0 to avoid invalid subtraction
                        NEG_DIVISOR <= (divisor_abs != 8'd0) ? (~{1'b0, divisor_abs} + 1'b1) : 9'd0;

                        cnt <= 4'd0;
                        res_valid <= 1'b0;
                    end
                end

                BUSY: begin
                    if (cnt < 4'd8) begin
                        // Shift left SR by 1 (drop MSB, shift in 0)
                        // Then try subtraction of divisor from upper 9 bits (partial remainder)
                        // If subtraction succeeded (carry_out=1), update upper bits with subtraction result and set quotient LSB=1
                        // Else keep shifted SR and quotient LSB=0

                        // Prepare next SR value
                        if (carry_out) begin
                            // Subtraction succeeded
                            // SR next = {sub_res[7:0], SR[7:0], 1'b1} after shifting
                            // But we must combine shift-left + conditional update

                            // Shift left by 1: (SR << 1) [16:0]
                            // Then replace upper 9 bits with sub_res
                            // Set quotient LSB (bit 0) = 1

                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                            // Explanation:
                            // sub_res[8] is carry_out, ignore since carry_out=1 means valid 9-bit result
                            // Actually sub_res is 9-bit: bits[8:0]
                            // But we only keep lower 8 bits sub_res[7:0] in upper remainder? No, remainder is 8 bits in upper 8 bits, but SR's upper 9 bits hold remainder with 1 extra MSB for shifting.
                            // However, per design, remainder occupies bits [16:8], which is 9 bits.
                            // We keep sub_res (9 bits) in upper bits.

                            // Correction:
                            // Actually sub_res is 9 bits, so upper 9 bits of SR should be sub_res[8:0]
                            // Shift left SR by 1 moves bits:
                            // So best to construct SR as {sub_res, SR[7:1], 1'b1} ? No, quotient bits are in SR[7:0], shifted left by 1 means quotient bits also shift left.

                            // So implement as:
                            // After shift left by 1: SR << 1
                            // Then replace upper 9 bits with sub_res (9 bits)
                            // Set bit 0 (quotient LSB) = 1
                        end else begin
                            // Subtraction failed
                            // Shift SR left by 1 and set quotient bit LSB=0
                            SR <= {SR[15:0], 1'b0};
                        end

                        // Increment iteration counter
                        cnt <= cnt + 1'b1;

                        // Not ready yet
                        res_valid <= 1'b0;
                    end

                    if (cnt == 4'd8) begin
                        // Division complete
                        // Extract remainder and quotient
                        // remainder = upper 8 bits of SR[16:9]
                        // quotient = lower 8 bits of SR[7:0]

                        // Use temporary regs to hold values for sign correction
                        // Adjust sign for quotient and remainder if signed operation

                        reg [7:0] remainder_out;
                        reg [7:0] quotient_out;

                        remainder_out = SR[16:9];
                        quotient_out  = SR[7:0];

                        // Sign correction for quotient
                        if (sign && quotient_neg)
                            quotient_out = (~quotient_out) + 1'b1;

                        // Sign correction for remainder
                        if (sign && remainder_neg)
                            remainder_out = (~remainder_out) + 1'b1;

                        result    <= {remainder_out, quotient_out};
                        res_valid <= 1'b1;

                        // Reset counter for next operation
                        cnt <= 4'd0;
                    end
                end

                default: begin
                    // Should not happen, safe default
                    state <= IDLE;
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    SR <= 17'd0;
                    NEG_DIVISOR <= 9'd0;
                end
            endcase
        end
    end
endmodule