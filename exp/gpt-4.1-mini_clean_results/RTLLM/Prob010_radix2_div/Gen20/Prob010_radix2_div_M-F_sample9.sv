module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result       // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam RUN   = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state, next_state;

    // Registers to store sign info and absolute inputs
    reg dividend_sign, divisor_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // 17-bit shift register: remainder(9 bits) | quotient(8 bits)
    reg [16:0] shift_reg, shift_reg_next;

    // Iteration counter (0 to 8)
    reg [3:0] count, count_next;

    // Raw results before sign correction
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Functions for absolute value and negation of 8-bit signed numbers
    function [7:0] abs8(input [7:0] val);
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    function [7:0] neg8(input [7:0] val);
        begin
            neg8 = ~val + 8'd1;
        end
    endfunction

    // FSM combinational logic
    always @(*) begin
        // Default next values
        next_state = state;
        shift_reg_next = shift_reg;
        count_next = count;

        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
            end
            RUN: begin
                if (count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                // Wait for new operation to start
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Division iteration combinational logic during RUN
    // Perform one division step: shift left shift_reg by 1, then trial subtract divisor from remainder
    // Update quotient bit accordingly

    reg [16:0] shift_reg_shifted;
    reg [8:0] trial_sub;
    reg trial_sub_nonneg;

    always @(*) begin
        // Default next shift_reg is current
        shift_reg_next = shift_reg;
        count_next = count;

        if (state == RUN && count < 4'd8) begin
            // Step 1: shift left shift_reg by 1
            // shift_reg[16:0] -> shift_reg_shifted[16:0] = {shift_reg[15:0], 1'b0}
            shift_reg_shifted = {shift_reg[15:0], 1'b0};

            // Step 2: trial subtract divisor from remainder (upper 9 bits)
            // remainder = bits [16:8] (9 bits), subtract 8-bit divisor extended with 0 MSB
            trial_sub = {1'b0, shift_reg_shifted[16:8]} - {1'b0, abs_divisor};
            trial_sub_nonneg = ~trial_sub[8]; // MSB=0 means no borrow (non-negative)

            if (trial_sub_nonneg) begin
                // Subtraction successful: update remainder bits with trial_sub result
                // Set quotient LSB = 1
                // Construct new shift_reg_next:
                // remainder = trial_sub[8:0]
                // quotient = shift_reg_shifted[7:1], quotient LSB replaced by 1
                shift_reg_next = {trial_sub[8:0], shift_reg_shifted[7:1], 1'b1};
            end else begin
                // Subtraction failed: restore remainder = shift_reg_shifted remainder (no subtraction)
                // quotient LSB remains 0
                // So just keep shift_reg_shifted as is
                shift_reg_next = shift_reg_shifted;
            end

            count_next = count + 1'b1;
        end
    end

    // Sequential logic for FSM and registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            shift_reg <= 17'd0;
            count <= 4'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            quotient_raw <= 8'd0;
            remainder_raw <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    quotient_raw <= 8'd0;
                    remainder_raw <= 8'd0;
                    shift_reg <= 17'd0;

                    if (opn_valid) begin
                        // Capture signs and absolute values if signed operation
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign <= divisor[7];
                            abs_dividend <= abs8(dividend);
                            abs_divisor <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor <= divisor;
                        end

                        // Initialize shift_reg:
                        // remainder = 0 (9 bits), quotient = abs_dividend (8 bits)
                        shift_reg <= {9'd0, abs_dividend};

                        count <= 4'd0;
                    end
                end

                RUN: begin
                    shift_reg <= shift_reg_next;
                    count <= count_next;
                end

                DONE: begin
                    // Latch raw quotient and remainder before sign correction
                    // remainder = upper 8 bits of remainder portion (bits 16:9) because remainder is 9 bits
                    quotient_raw <= shift_reg[7:0];
                    remainder_raw <= shift_reg[16:9];

                    res_valid <= 1'b1;

                    // If new opn_valid, start new operation
                    if (opn_valid) begin
                        // Capture new signs and absolutes for new operation
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign <= divisor[7];
                            abs_dividend <= abs8(dividend);
                            abs_divisor <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor <= divisor;
                        end

                        // Initialize for new division
                        shift_reg <= {9'd0, abs_dividend};
                        count <= 4'd0;
                        res_valid <= 1'b0;  // clear res_valid when starting new op
                        state <= RUN;       // move state directly to RUN
                    end
                end
            endcase
        end
    end

    // Sign correction and special divide-by-zero handling (sequential)
    // Output 'result' assigned here to avoid combinational output register assignments
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'd0;
        end else if (state == DONE) begin
            // Handle divide-by-zero case
            if (abs_divisor == 8'd0) begin
                // quotient = 0xFF
                // remainder = dividend (signed or unsigned as per sign)
                result[7:0]   <= 8'hFF;

                if (sign && dividend_sign)
                    result[15:8] <= neg8(abs_dividend);
                else
                    result[15:8] <= abs_dividend;
            end else begin
                // Normal division, apply sign correction if needed
                reg [7:0] quotient_signed;
                reg [7:0] remainder_signed;

                if (sign) begin
                    // Quotient sign = dividend_sign XOR divisor_sign
                    if (dividend_sign ^ divisor_sign)
                        quotient_signed = neg8(quotient_raw);
                    else
                        quotient_signed = quotient_raw;

                    // Remainder sign same as dividend_sign
                    if (dividend_sign)
                        remainder_signed = neg8(remainder_raw);
                    else
                        remainder_signed = remainder_raw;
                end else begin
                    quotient_signed = quotient_raw;
                    remainder_signed = remainder_raw;
                end

                result <= {remainder_signed, quotient_signed};
            end
        end
    end

endmodule