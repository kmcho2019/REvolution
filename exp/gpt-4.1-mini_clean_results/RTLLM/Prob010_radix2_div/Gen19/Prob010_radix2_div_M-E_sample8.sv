module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    input               res_ready,       // input handshake to clear res_valid and accept new operation
    output reg          res_valid,
    output reg  [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam RUN   = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state, next_state;

    // Signals for absolute values and sign flags
    reg dividend_sign, divisor_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // 17-bit shift register: [16:8] remainder (9 bits), [7:0] quotient (8 bits)
    reg [16:0] shift_reg;

    // Iteration counter
    reg [3:0] count;

    // Subtraction trial signals
    reg [8:0] trial_sub;
    reg       trial_sub_nonneg;

    // Internal registers for sign-corrected outputs
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Helper functions for absolute value and negation of 8-bit signed number
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 8'd1;
        end
    endfunction

    // Compute next_state combinationally
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (count == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                // Wait for res_ready and no new opn_valid to return to IDLE
                if (res_ready && !opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            shift_reg   <= 17'd0;
            count       <= 4'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            abs_dividend  <= 8'd0;
            abs_divisor   <= 8'd0;
            quotient_raw  <= 8'd0;
            remainder_raw <= 8'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    quotient_raw  <= 8'd0;
                    remainder_raw <= 8'd0;
                    if (opn_valid) begin
                        // Capture signs and absolute values if signed division
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            abs_dividend  <= abs8(dividend);
                            abs_divisor   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            abs_dividend  <= dividend;
                            abs_divisor   <= divisor;
                        end

                        // Initialize shift_reg:
                        // remainder upper 9 bits = 0 (zero extended 9 bits)
                        // quotient lower 8 bits = abs_dividend
                        // shift_reg = {9'd0, abs_dividend}
                        shift_reg <= {9'd0, abs_dividend};
                    end
                end

                RUN: begin
                    // Perform one division iteration per clock
                    // Step 1: Shift shift_reg left by 1 bit
                    // This shifts quotient bits left and introduces a zero bit in quotient LSB for now
                    // shift_reg[16:0] <= {shift_reg[15:0], 1'b0}
                    shift_reg <= {shift_reg[15:0], 1'b0};

                    // After shift, remainder is shift_reg[16:8], quotient is shift_reg[7:0]
                    // Trial subtraction: remainder - divisor
                    trial_sub = {1'b0, shift_reg[16:8]} - {1'b0, abs_divisor};
                    trial_sub_nonneg = ~trial_sub[8]; // MSB = 0 means no borrow => nonnegative

                    // Update remainder and quotient bit if subtraction nonnegative
                    if (trial_sub_nonneg) begin
                        // Place result of subtraction in remainder bits [16:8]
                        shift_reg[16:8] <= trial_sub[8:0];
                        // Set quotient LSB (bit 0) to 1 (overwrite shifted zero)
                        shift_reg[0] <= 1'b1;
                    end else begin
                        // Subtraction negative => restore remainder (no change needed because shift_reg already shifted),
                        // quotient bit remains 0 from shift
                        // So no extra assignment needed here, only increment count
                    end

                    count <= count + 1'b1;
                end

                DONE: begin
                    // Division finished - extract raw quotient and remainder before sign correction
                    quotient_raw  <= shift_reg[7:0];
                    remainder_raw <= shift_reg[16:9];

                    res_valid <= 1'b1;

                    // On next clock, after outputs latched, apply sign correction and output result
                    // But to avoid combinational loops, sign correction is done here after raw assigned last cycle before DONE

                    // Wait here until res_ready and no new operation request to reset
                    if (res_ready && !opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Sign correction combinational logic for output result and special div-by-zero handling
    always @(*) begin
        // Default values for output
        reg [7:0] quotient_signed;
        reg [7:0] remainder_signed;

        if (state == DONE) begin
            // Handle divide-by-zero: divisor == 0
            if (abs_divisor == 8'd0) begin
                // According to spec:
                // quotient = 0xFF (all ones)
                // remainder = dividend (signed or unsigned as per sign)
                quotient_signed  = 8'hFF;
                if (sign && dividend_sign)
                    remainder_signed = neg8(abs_dividend);
                else
                    remainder_signed = abs_dividend;
            end else begin
                // Normal division, sign correct quotient and remainder if signed
                if (sign) begin
                    // Quotient sign: XOR of dividend and divisor sign bits
                    if (dividend_sign ^ divisor_sign)
                        quotient_signed = neg8(quotient_raw);
                    else
                        quotient_signed = quotient_raw;

                    // Remainder sign same as dividend sign
                    if (dividend_sign)
                        remainder_signed = neg8(remainder_raw);
                    else
                        remainder_signed = remainder_raw;
                end else begin
                    quotient_signed = quotient_raw;
                    remainder_signed = remainder_raw;
                end
            end
        end else begin
            quotient_signed = 8'd0;
            remainder_signed = 8'd0;
        end

        // Pack output result: upper 8 bits remainder, lower 8 bits quotient
        result = {remainder_signed, quotient_signed};
    end

endmodule