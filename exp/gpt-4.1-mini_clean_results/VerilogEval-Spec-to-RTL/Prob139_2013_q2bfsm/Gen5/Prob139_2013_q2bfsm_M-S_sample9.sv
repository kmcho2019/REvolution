module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        STATE_A       = 3'd0, // reset/idle
        F_PULSE       = 3'd1, // f=1 one cycle after reset release
        PATTERN_DETECT = 3'd2, // detecting 1-0-1 on x
        MONITOR_Y     = 3'd3, // g=1, monitoring y for up to 2 cycles
        G_ON_PERM     = 3'd4, // permanent g=1
        G_OFF_PERM    = 3'd5  // permanent g=0
    } state_t;

    state_t state, next_state;

    // Pattern detection progress: counts matched bits (0 to 3)
    // 0 = no bits matched yet
    // We track 3 bits: 1,0,1 successively
    logic [1:0] pattern_idx; // 0..3

    // y monitor count: counts how many cycles since asserting g=1
    logic [1:0] y_count;

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            pattern_idx <= 2'd0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            // Update pattern_idx when in PATTERN_DETECT
            if (state == PATTERN_DETECT) begin
                case (pattern_idx)
                    2'd0: if (x == 1'b1) pattern_idx <= 2'd1;
                    2'd1: if (x == 1'b0) pattern_idx <= 2'd2;
                          else if (x == 1'b1) pattern_idx <= 2'd1; // stay if repeating 1
                          else pattern_idx <= 2'd0;
                    2'd2: if (x == 1'b1) pattern_idx <= 2'd3; 
                          else if (x == 1'b1) pattern_idx <= 2'd1; // restart if new 1
                          else pattern_idx <= 2'd0;
                    default: pattern_idx <= 2'd0;
                endcase
            end else begin
                pattern_idx <= 2'd0; // reset when not detecting pattern
            end

            // Update y_count when monitoring y
            if (state == MONITOR_Y) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            STATE_A: begin
                // Hold while resetn low
                if (resetn)
                    next_state = F_PULSE; // move after reset released
            end

            F_PULSE: begin
                // After one cycle with f=1, start pattern detection
                next_state = PATTERN_DETECT;
            end

            PATTERN_DETECT: begin
                // Wait for pattern_idx==3 (pattern 1-0-1 matched)
                if (pattern_idx == 2'd3)
                    next_state = MONITOR_Y;
                else
                    next_state = PATTERN_DETECT;
            end

            MONITOR_Y: begin
                // g=1 asserted, monitor y for up to 2 cycles
                if (y == 1'b1) begin
                    next_state = G_ON_PERM; // y detected, g=1 permanently
                end else if (y_count == 2'd2) begin
                    next_state = G_OFF_PERM; // time expired without y=1
                end else begin
                    next_state = MONITOR_Y; // keep monitoring
                end
            end

            G_ON_PERM: begin
                // stay here until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // stay here until reset
                next_state = G_OFF_PERM;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Output logic (Moore)
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
                PATTERN_DETECT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                MONITOR_Y: begin
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