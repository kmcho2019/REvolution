module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers for operands and sign flags
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg       quotient_neg, remainder_neg;

    // Absolute values of inputs
    reg [7:0] dividend_abs, divisor_abs;

    // Internal datapath registers
    reg [8:0] remainder;     // 9-bit remainder: allow one extra bit for shifting
    reg [7:0] quotient;

    // Bit counter for 8 iterations
    reg [3:0] bit_count;

    // Division by zero flag
    wire divisor_zero = (divisor_reg == 8'b0);

    // Compute absolute values and signs combinationally
    function [7:0] abs_val(input [7:0] val);
        abs_val = (val[7]) ? (~val + 8'd1) : val;
    endfunction

    // Sequential logic: FSM state transition
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for opn_valid and no result pending
                if (opn_valid)
                    next_state = RUNNING;
            end
            RUNNING: begin
                // After 8 bits processed, move to DONE
                if (bit_count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                // Wait for opn_valid to clear or new operation
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Division process and datapath
    always @(posedge clk) begin
        if (rst) begin
            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            remainder <= 9'b0;
            quotient <= 8'b0;
            bit_count <= 4'b0;
            result <= 16'b0;
            res_valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;

                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        dividend_neg <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg  <= (sign) ? divisor[7] : 1'b0;

                        quotient_neg <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        dividend_abs <= abs_val(dividend);
                        divisor_abs <= abs_val(divisor);

                        remainder <= 9'b0;
                        quotient <= 8'b0;

                        bit_count <= 4'b0;
                    end
                end

                RUNNING: begin
                    // If division by zero, skip iterations and output zero immediately in DONE state
                    if (divisor_zero) begin
                        // Wait in RUNNING state until transitions to DONE (handled by FSM)
                        remainder <= 9'b0;
                        quotient <= 8'b0;
                        bit_count <= 4'd8; // Force completion
                    end else begin
                        // Shift left remainder by 1, bring next bit from dividend_abs MSB-first
                        // The bits are fed MSB to LSB, so extract bit at (7 - bit_count)
                        remainder <= {remainder[7:0], dividend_abs[7 - bit_count]};

                        // Next cycle we do subtract if remainder >= divisor_abs

                        // Note: subtraction happens combinationally in next cycle; here just shift

                        bit_count <= bit_count + 1'b1;
                    end
                end

                DONE: begin
                    // Compute final quotient and remainder with sign correction

                    // Handle division by zero: result already zero

                    // Correct quotient sign if needed
                    reg [7:0] quotient_signed;
                    reg [8:0] remainder_signed;

                    if (divisor_zero) begin
                        quotient_signed = 8'b0;
                        remainder_signed = 9'b0;
                    end else begin
                        // Check if remainder >= divisor_abs (for the final remainder)
                        // In final state, the remainder is as computed in previous steps
                        // For the last shift, we already shifted in the last dividend bit in RUNNING
                        // But we still need to test subtraction once more:

                        if (remainder >= {1'b0, divisor_abs}) begin
                            // Subtract divisor_abs from remainder and set last quotient bit
                            remainder = remainder - {1'b0, divisor_abs};
                            quotient = quotient | 1'b1; // Set LSB quotient bit
                        end

                        // Quotient sign correction
                        quotient_signed = quotient_neg ? (~quotient + 8'd1) : quotient;
                        // Remainder sign correction (only lower 8 bits are output)
                        remainder_signed = remainder_neg ? (~remainder + 9'd1) : remainder;
                    end

                    result <= {remainder_signed[7:0], quotient_signed};
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // Combinational subtraction and quotient bit update within RUNNING state (for 8 iterations)
    always @(posedge clk) begin
        if (!rst && state == RUNNING && !divisor_zero && bit_count != 4'd8) begin
            // After shifting in the new bit in remainder, try subtract divisor_abs
            if (remainder >= {1'b0, divisor_abs}) begin
                remainder <= remainder - {1'b0, divisor_abs};
                quotient <= (quotient << 1) | 1'b1;
            end else begin
                quotient <= (quotient << 1);
                // remainder unchanged (already shifted in above)
            end
        end
    end

endmodule