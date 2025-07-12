module TopModule(
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE        = 3'd0,  // waiting for reset release
        PULSE_F     = 3'd1,  // output f=1 one cycle after reset released
        WAIT_PATTERN= 3'd2,  // monitor x for pattern 1,0,1 via pattern_index
        SET_G       = 3'd3,  // output g=1 one cycle after pattern detected
        MONITOR_Y   = 3'd4,  // g=1, monitor y for up to 2 cycles
        PERM_G_ON   = 3'd5,  // g=1 permanently until reset
        PERM_G_OFF  = 3'd6   // g=0 permanently until reset
    } state_t;

    reg [2:0] state, next_state;

    // Pattern index tracks how many elements of 1,0,1 matched so far:
    // 0 = none matched, waiting for first 1
    // 1 = matched first 1, waiting for 0
    // 2 = matched 1,0 waiting for last 1
    reg [1:0] pattern_index, next_pattern_index;

    // y counter for monitoring y signal (counts cycles in MONITOR_Y)
    reg [1:0] y_count, next_y_count;

    // FSM sequential update
    always @(posedge clk) begin
        if (!resetn) begin
            state         <= IDLE;
            pattern_index <= 2'd0;
            y_count       <= 2'd0;
            f             <= 1'b0;
            g             <= 1'b0;
        end else begin
            state         <= next_state;
            pattern_index <= next_pattern_index;
            y_count       <= next_y_count;
            // f and g updated combinationally below (could update here too)
        end
    end

    // FSM combinational next state and outputs
    always @(*) begin
        // Defaults
        next_state         = state;
        next_pattern_index = pattern_index;
        next_y_count       = y_count;
        f                  = 1'b0;
        g                  = 1'b0;

        case (state)
            IDLE: begin
                // Stay here until reset deasserted (synchronous reset already handled)
                // After reset released, go to PULSE_F
                next_state = PULSE_F;
            end

            PULSE_F: begin
                // Output f=1 exactly one cycle here
                f = 1'b1;
                // Then go to pattern wait
                next_state         = WAIT_PATTERN;
                next_pattern_index = 2'd0;
            end

            WAIT_PATTERN: begin
                // Output f=0, g=0 here

                // Pattern to detect is 1,0,1
                // pattern_index states:
                // 0: expecting 1
                // 1: expecting 0
                // 2: expecting 1
                // When pattern_index reaches 3 (end), trigger next_state SET_G

                case (pattern_index)
                    2'd0: begin
                        if (x == 1'b1)
                            next_pattern_index = 2'd1; // matched first 1
                        else
                            next_pattern_index = 2'd0; // wait for first 1
                    end
                    2'd1: begin
                        if (x == 1'b0)
                            next_pattern_index = 2'd2; // matched 0
                        else if (x == 1'b1)
                            next_pattern_index = 2'd1; // repeated 1 (stay here)
                        else
                            next_pattern_index = 2'd0; // reset on invalid
                    end
                    2'd2: begin
                        if (x == 1'b1)
                            next_state = SET_G; // pattern complete
                        else if (x == 1'b0)
                            next_pattern_index = 2'd0; // mismatch, restart
                        else
                            next_pattern_index = 2'd0; // reset default
                    end
                    default: next_pattern_index = 2'd0;
                endcase

                g = 1'b0;
                f = 1'b0;
            end

            SET_G: begin
                // Output g=1 exactly one cycle
                g = 1'b1;
                f = 1'b0;
                // Then go to MONITOR_Y to monitor y for 2 cycles
                next_state   = MONITOR_Y;
                next_y_count = 2'd0;
                // Reset pattern_index since no longer needed
                next_pattern_index = 2'd0;
            end

            MONITOR_Y: begin
                // g=1 while monitoring y for 2 cycles max
                g = 1'b1;
                f = 1'b0;

                if (y == 1'b1) begin
                    // y=1 detected within monitoring period -> PERM_G_ON
                    next_state   = PERM_G_ON;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // 2 cycles elapsed, no y=1 -> PERM_G_OFF
                    next_state   = PERM_G_OFF;
                    next_y_count = 2'd0;
                end else begin
                    // Increment count and stay here
                    next_state   = MONITOR_Y;
                    next_y_count = y_count + 1'b1;
                end
            end

            PERM_G_ON: begin
                // g=1 permanently until reset
                g = 1'b1;
                f = 1'b0;
                next_state = PERM_G_ON;
                next_y_count = 2'd0;
                next_pattern_index = 2'd0;
            end

            PERM_G_OFF: begin
                // g=0 permanently until reset
                g = 1'b0;
                f = 1'b0;
                next_state = PERM_G_OFF;
                next_y_count = 2'd0;
                next_pattern_index = 2'd0;
            end

            default: begin
                // Safety fallback to IDLE
                next_state = IDLE;
                next_pattern_index = 2'd0;
                next_y_count = 2'd0;
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule