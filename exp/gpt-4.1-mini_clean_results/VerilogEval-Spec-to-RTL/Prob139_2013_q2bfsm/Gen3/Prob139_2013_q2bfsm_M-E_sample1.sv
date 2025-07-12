module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);
    // State encoding: one-hot style for clarity
    typedef enum logic [2:0] {
        STATE_A       = 3'd0, // Reset / idle state
        F_PULSE       = 3'd1, // Assert f=1 for one clock cycle after reset release
        SEQ_1         = 3'd2, // Detected first '1' of pattern on x
        SEQ_10        = 3'd3, // Detected '1','0' on x
        SEQ_101       = 3'd4, // Pattern matched (ready to assert g)
        MONITOR_Y_0   = 3'd5, // Monitor y input cycle 1 with g=1
        MONITOR_Y_1   = 3'd6, // Monitor y input cycle 2 with g=1
        G_ON_PERM     = 3'd7, // Permanently g=1
        G_OFF_PERM    = 3'd8  // Permanently g=0
    } state_t;

    state_t state, next_state;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default hold state
        next_state = state;

        case (state)
            STATE_A: begin
                // Hold here as long as resetn is low
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // After asserting f, move to start sequence detection on x
                next_state = SEQ_1;
            end

            SEQ_1: begin
                // Looking for first bit '1' of pattern on x
                if (x == 1'b1)
                    next_state = SEQ_10;  // matched first bit
                else
                    next_state = SEQ_1;   // keep waiting for 1
            end

            SEQ_10: begin
                // After matching '1', expect '0'
                if (x == 1'b0)
                    next_state = SEQ_101; // matched second bit
                else if (x == 1'b1)
                    next_state = SEQ_10;  // still might be start of pattern again (overlapping)
                else
                    next_state = SEQ_1;   // reset detection
            end

            SEQ_101: begin
                // After '1','0', next x must be '1' for full pattern
                if (x == 1'b1)
                    next_state = MONITOR_Y_0; // pattern found, go to monitor y
                else if (x == 1'b0)
                    next_state = SEQ_1; // restart detecting pattern from first bit
                else
                    next_state = SEQ_1; 
            end

            MONITOR_Y_0: begin
                // g=1 asserted, first cycle monitoring y
                if (y == 1'b1)
                    next_state = G_ON_PERM; // y=1 detected within window
                else
                    next_state = MONITOR_Y_1; // else check second cycle
            end

            MONITOR_Y_1: begin
                // g=1 asserted, second cycle monitoring y
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM; // y not detected within 2 cycles
            end

            G_ON_PERM: begin
                // Permanently g=1 until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Permanently g=0 until reset
                next_state = G_OFF_PERM;
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output logic synchronous and only depends on state (Moore outputs)
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end

                SEQ_1, SEQ_10, SEQ_101: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                MONITOR_Y_0, MONITOR_Y_1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_ON_PERM: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_OFF_PERM: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule