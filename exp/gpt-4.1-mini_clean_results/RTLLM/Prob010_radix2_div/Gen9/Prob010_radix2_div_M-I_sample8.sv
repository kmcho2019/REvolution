module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states (3-state FSM for clear control)
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;

    state_t state, next_state;

    // Latched inputs and sign info
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register 16 bits: [15:8] remainder (8 bits), [7:0] quotient (8 bits)
    reg [15:0] SR;

    // Counter 0..8 iterations
    reg [3:0] cnt;

    // Wires for remainder and quotient parts
    wire [7:0] remainder = SR[15:8];
    wire [7:0] quotient  = SR[7:0];

    // 9-bit subtract to detect borrow: remainder - divisor_abs
    wire [8:0] sub_res = {1'b0, remainder} - {1'b0, divisor_abs};
    wire borrow = sub_res[8]; // MSB is borrow indicator
    wire q_bit = borrow ? 1'b0 : 1'b1;
    wire [7:0] next_remainder = borrow ? remainder : sub_res[7:0];

    // Sequential FSM and data path
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            cnt          <= 4'd0;
            SR           <= 16'd0;
            res_valid    <= 1'b0;
            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            result       <= 16'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    SR <= 16'd0;
                    if (opn_valid && divisor != 8'd0) begin
                        // Latch operands
                        dividend_r <= dividend;
                        divisor_r  <= divisor;
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            // Absolute values
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs  <= divisor[7]  ? (~divisor  + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;
                        end
                        // Initialize SR with remainder=0, quotient=dividend_abs
                        SR <= {8'd0, dividend_abs};
                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (cnt < 4'd8) begin
                        // Iteration step:
                        // Shift left {remainder, quotient} by 1 bit and input q_bit as LSB of quotient
                        SR <= {next_remainder, SR[7:1], q_bit};
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    // Compute signed corrections
                    // Perform only once at start of DONE state
                    // quotient sign: XOR of dividend_neg and divisor_neg
                    // remainder sign: same as dividend_neg
                    reg [7:0] corr_quotient;
                    reg [7:0] corr_remainder;

                    // Using regs inside always block requires a nested begin-end for new regs
                    // Instead, use combinational logic outside always block and latch in DONE state

                    // No update of SR or cnt in DONE

                    // res_valid asserted here and held until reset or new opn_valid

                    // We move the sign correction logic to a combinational always block below
                    // Just hold result here
                end

                default: begin
                    // fallback safe state
                    state <= IDLE;
                    cnt <= 4'd0;
                    SR <= 16'd0;
                    res_valid <= 1'b0;
                end
            endcase

            // Result valid signal assertion logic
            // Transition from DIVIDE to DONE means division complete
            if (state == DIVIDE && cnt == 4'd8)
                res_valid <= 1'b1;

            // Capture result at DONE state start
            if (state == DONE) begin
                result <= {corr_remainder, corr_quotient};
            end

            // Clear res_valid and prepare for next operation when new opn_valid in IDLE
            if (state == IDLE && opn_valid && divisor != 8'd0)
                res_valid <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            end
            DONE: begin
                // Wait for res_valid to be consumed by external logic
                // For simplicity, next operation start transitions to IDLE
                if (opn_valid && divisor != 8'd0)
                    next_state = DIVIDE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Signed correction combinational logic outside sequential block
    reg [7:0] corr_quotient, corr_remainder;

    always @(*) begin
        // Default output from SR
        reg [7:0] raw_quotient = SR[7:0];
        reg [7:0] raw_remainder = SR[15:8];

        if (sign) begin
            // Quotient sign correction: dividend_neg XOR divisor_neg
            if (dividend_neg ^ divisor_neg)
                corr_quotient = (~raw_quotient + 8'd1);
            else
                corr_quotient = raw_quotient;

            // Remainder sign correction: same sign as dividend_neg
            if (dividend_neg)
                corr_remainder = (~raw_remainder + 8'd1);
            else
                corr_remainder = raw_remainder;
        end else begin
            corr_quotient = raw_quotient;
            corr_remainder = raw_remainder;
        end
    end

endmodule