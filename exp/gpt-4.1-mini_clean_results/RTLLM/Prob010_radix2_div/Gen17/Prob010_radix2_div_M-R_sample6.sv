module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // States for state machine
    typedef enum reg [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;
    state_t state, next_state;

    // Registers to hold absolute values and signs
    reg [7:0] dividend_abs, divisor_abs;
    reg dividend_sign, divisor_sign;

    // Shift register holds remainder (upper 8 bits) and partial quotient (lower 8 bits)
    reg [16:0] shift_reg; 
    // 17 bits because we shift left each cycle and insert quotient bit at LSB, remainder is upper 9 bits during calc

    // Counter for 8 division cycles
    reg [3:0] count;

    // Signals for subtraction trial and quotient bit decision
    wire [8:0] remainder_trial;      // 9 bits remainder with MSB sign extension
    wire [8:0] subtract_result;      // result of remainder_trial - divisor_abs
    wire       subtraction_non_neg;  // indicates if subtract_result >= 0

    // Quotient and remainder registers to store final results before sign correction
    reg [7:0] quotient;
    reg [7:0] remainder;

    // Final signed quotient and remainder after sign correction
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Functions for absolute and negate (two's complement)
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

    // Combinational signals for trial remainder (9 bits)
    // remainder_trial = (remainder << 1) | next_bit_from_shift_reg[16]
    // remainder is upper 8 bits of shift_reg[16:9]
    assign remainder_trial = {shift_reg[16], shift_reg[16:9]} << 1 | shift_reg[8];
    // Perform subtraction trial: remainder_trial - divisor_abs
    assign subtract_result = remainder_trial - {1'b0, divisor_abs};
    assign subtraction_non_neg = ~subtract_result[8]; // MSB sign bit 0 means non-negative

    // Sequential logic for state transitions and operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            shift_reg      <= 17'd0;
            count          <= 4'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            quotient       <= 8'd0;
            remainder      <= 8'd0;
            final_quotient <= 8'd0;
            final_remainder<= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Handle signs and absolute values
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            dividend_abs  <= abs8(dividend);
                            divisor_abs   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            dividend_abs  <= dividend;
                            divisor_abs   <= divisor;
                        end

                        // Initialize shift register:
                        // remainder = 0, partial quotient = 0
                        // Load dividend_abs into lower 8 bits shifted left by 1 for LSB = 0
                        // shift_reg = {0, 0, dividend_abs[7:0], 0}
                        shift_reg <= {9'd0, dividend_abs, 1'b0};

                        count    <= 4'd0;

                        state <= (divisor_abs == 8'd0) ? DONE : DIVIDE; // handle div by zero later
                    end
                end

                DIVIDE: begin
                    // Perform subtraction trial and update shift_reg
                    // shift_reg format during division:
                    // bits [16:9]: remainder (9 bits, including sign extension)
                    // bits [8:0]: bits left to process (LSB includes quotient bits being formed)

                    if (count < 8) begin
                        if (subtraction_non_neg) begin
                            // subtraction successful: update remainder with subtract_result lower 8 bits
                            // shift left shift_reg by 1 bit, insert '1' as new quotient bit
                            shift_reg <= {subtract_result[7:0], shift_reg[7:0], 1'b1};
                        end else begin
                            // subtraction negative: shift left shift_reg by 1 bit, insert '0' as quotient bit
                            shift_reg <= {remainder_trial[7:0], shift_reg[7:0], 1'b0};
                        end
                        count <= count + 1'b1;
                    end else begin
                        // Division done: capture quotient and remainder and move to DONE state
                        // quotient in lower 8 bits, remainder in upper 8 bits
                        quotient  <= shift_reg[7:0];
                        remainder <= shift_reg[16:9];
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Handle division by zero: if divisor_abs == 0
                    if (divisor_abs == 8'd0) begin
                        // Quotient = 0xFF, remainder = dividend_abs (or original dividend if signed)
                        final_quotient  <= 8'hFF;
                        final_remainder <= dividend_abs;
                    end else begin
                        // Adjust sign if signed operation
                        if (sign) begin
                            // Quotient sign = dividend_sign XOR divisor_sign
                            if (dividend_sign ^ divisor_sign)
                                final_quotient <= neg8(quotient);
                            else
                                final_quotient <= quotient;

                            // Remainder sign = dividend_sign
                            if (dividend_sign)
                                final_remainder <= neg8(remainder);
                            else
                                final_remainder <= remainder;
                        end else begin
                            final_quotient  <= quotient;
                            final_remainder <= remainder;
                        end
                    end
                    // Output result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;

                    // Wait for new operation (opn_valid low) to go back to IDLE
                    if (!opn_valid) begin
                        state <= IDLE;
                        res_valid <= 1'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule