module TopModule(
    input wire clk,
    input wire resetn,
    input wire x,
    input wire y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A           = 3'd0, // Reset state
        F_PULSE     = 3'd1, // Output f=1 for one cycle
        MONITOR_X   = 3'd2, // Detect 1,0,1 pattern on x
        G_MONITOR_Y = 3'd3, // g=1, monitor y for up to 2 cycles
        G_ON        = 3'd4, // g=1 permanently
        G_OFF       = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Pattern match index:
    // 0: expect first '1'
    // 1: expect '0'
    // 2: expect last '1'
    // 3: pattern matched (trigger transition)
    reg [1:0] pattern_match_index, pattern_match_index_next;

    // y_counter counts cycles monitoring y in G_MONITOR_Y state (0..2)
    reg [1:0] y_counter, y_counter_next;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            pattern_match_index <= 2'd0;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;
            pattern_match_index <= pattern_match_index_next;
            y_counter <= y_counter_next;
        end
    end

    // Next-state logic and register updates
    always @(*) begin
        // Defaults
        next_state = state;
        pattern_match_index_next = 2'd0;
        y_counter_next = 2'd0;

        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
                // pattern_match_index and y_counter reset on exit from reset
                pattern_match_index_next = 2'd0;
                y_counter_next = 2'd0;
            end

            F_PULSE: begin
                // One cycle f=1, then start pattern detection
                next_state = MONITOR_X;
                pattern_match_index_next = 2'd0;
                y_counter_next = 2'd0;
            end

            MONITOR_X: begin
                // Strict pattern detection 1,0,1 on x
                // pattern_match_index indicates which bit expected next
                // Compute next pattern_match_index_next based on x
                case (pattern_match_index)
                    2'd0: begin
                        // Expect 1
                        if (x == 1'b1)
                            pattern_match_index_next = 2'd1; // matched first '1', expect '0' next
                        else
                            pattern_match_index_next = 2'd0; // stay waiting for first '1'
                    end
                    2'd1: begin
                        // Expect 0
                        if (x == 1'b0)
                            pattern_match_index_next = 2'd2; // matched '0', expect final '1' next
                        else if (x == 1'b1)
                            // Restart pattern from step 1 (another '1'), possible overlapping patterns
                            pattern_match_index_next = 2'd1;
                        else
                            pattern_match_index_next = 2'd0;
                    end
                    2'd2: begin
                        // Expect last 1
                        if (x == 1'b1)
                            pattern_match_index_next = 2'd3; // pattern matched
                        else
                            pattern_match_index_next = 2'd0; // mismatch, reset
                    end
                    default: pattern_match_index_next = 2'd0;
                endcase

                // Transition to next state if pattern matched
                if (pattern_match_index_next == 2'd3) begin
                    next_state = G_MONITOR_Y;
                    // Reset pattern_match_index next since we won't use it outside MONITOR_X
                    pattern_match_index_next = 2'd0;
                    y_counter_next = 2'd0;
                end else begin
                    next_state = MONITOR_X;
                    // y_counter not used here
                    y_counter_next = 2'd0;
                end
            end

            G_MONITOR_Y: begin
                // On entry or continuation in G_MONITOR_Y, increment y_counter
                y_counter_next = y_counter + 1'b1;

                // If y=1 within 2 cycles, go to G_ON
                if (y == 1'b1) begin
                    next_state = G_ON;
                    y_counter_next = 2'd0; // no longer needed
                    pattern_match_index_next = 2'd0;
                end
                // Else after 2 cycles (0,1,2) without y=1, go G_OFF
                else if (y_counter == 2'd2) begin
                    next_state = G_OFF;
                    y_counter_next = 2'd0;
                    pattern_match_index_next = 2'd0;
                end
                else begin
                    next_state = G_MONITOR_Y;
                    pattern_match_index_next = 2'd0;
                end
            end

            G_ON: begin
                // Permanent g=1 until reset
                next_state = G_ON;
                pattern_match_index_next = 2'd0;
                y_counter_next = 2'd0;
            end

            G_OFF: begin
                // Permanent g=0 until reset
                next_state = G_OFF;
                pattern_match_index_next = 2'd0;
                y_counter_next = 2'd0;
            end

            default: begin
                next_state = A;
                pattern_match_index_next = 2'd0;
                y_counter_next = 2'd0;
            end
        endcase
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            A: begin
                f = 1'b0;
                g = 1'b0;
            end

            F_PULSE: begin
                f = 1'b1; // one cycle pulse after reset
                g = 1'b0;
            end

            MONITOR_X: begin
                f = 1'b0;
                g = 1'b0;
            end

            G_MONITOR_Y: begin
                f = 1'b0;
                g = 1'b1;
            end

            G_ON: begin
                f = 1'b0;
                g = 1'b1;
            end

            G_OFF: begin
                f = 1'b0;
                g = 1'b0;
            end

            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule