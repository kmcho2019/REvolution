module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding (Moore FSM)
    typedef enum logic [2:0] {
        A             = 3'd0, // Reset state, waiting for reset de-assertion
        F_PULSE       = 3'd1, // Assert f=1 for exactly one clock cycle
        MONITOR_X     = 3'd2, // Monitor x for pattern 1,0,1
        G_ON_MONITOR_Y= 3'd3, // g=1, monitor y input up to 2 cycles
        G_ON_PERM     = 3'd4, // g=1 permanently
        G_OFF_PERM    = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_step tracks pattern matching progress on x: 0 to 3
    reg [1:0] pattern_step, next_pattern_step;

    // y_count counts cycles spent in G_ON_MONITOR_Y (max 2)
    reg [1:0] y_count, next_y_count;

    // Sequential logic for state, pattern_step, y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
        end else begin
            state        <= next_state;
            pattern_step <= next_pattern_step;
            y_count      <= next_y_count;
        end
    end

    // Combinational logic to compute next state and counters
    always @(*) begin
        // Defaults: hold current values
        next_state        = state;
        next_pattern_step = 2'd0;
        next_y_count      = 2'd0;

        case (state)
            A: begin
                // Stay in A while reset asserted (active low)
                // When resetn de-asserted, move to F_PULSE next cycle
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;

                // pattern_step and y_count reset at A
                next_pattern_step = 2'd0;
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // f=1 only in this state, one cycle
                next_state = MONITOR_X;

                // Reset counters when entering MONITOR_X
                next_pattern_step = 2'd0;
                next_y_count = 2'd0;
            end

            MONITOR_X: begin
                // Pattern detection logic for x sequence 1,0,1 with overlapping detection
                // pattern_step meaning:
                // 0: waiting for first 1
                // 1: got 1, waiting for 0
                // 2: got 1,0, waiting for 1
                // 3: pattern matched

                // Default is to keep pattern_step unless updated below
                case (pattern_step)
                    2'd0: begin
                        // Waiting for first '1'
                        if (x == 1'b1)
                            next_pattern_step = 2'd1;
                        else
                            next_pattern_step = 2'd0;
                        next_state = MONITOR_X;
                    end
                    2'd1: begin
                        // Got first 1, expecting 0
                        if (x == 1'b0)
                            next_pattern_step = 2'd2;
                        else if (x == 1'b1)
                            // Stay at step 1 to handle overlapping sequence
                            next_pattern_step = 2'd1;
                        else
                            next_pattern_step = 2'd0;
                        next_state = MONITOR_X;
                    end
                    2'd2: begin
                        // Got 1,0, expecting last 1
                        if (x == 1'b1)
                            next_pattern_step = 2'd3; // pattern matched
                        else if (x == 1'b0)
                            next_pattern_step = 2'd0;
                        else
                            next_pattern_step = 2'd0;
                        next_state = MONITOR_X;
                    end
                    2'd3: begin
                        // Pattern matched, move to next state
                        next_pattern_step = 2'd3;
                        next_state = G_ON_MONITOR_Y;
                    end
                    default: begin
                        next_pattern_step = 2'd0;
                        next_state = MONITOR_X;
                    end
                endcase

                // Reset y_count in MONITOR_X
                next_y_count = 2'd0;
            end

            G_ON_MONITOR_Y: begin
                // g=1, monitor y input for at most 2 cycles since entry
                // y_count counts cycles spent, starting from 0 at entry
                // If y==1 any cycle, move to G_ON_PERM
                // If y_count == 2 (means 2 cycles elapsed without y==1), move to G_OFF_PERM
                if (y == 1'b1) begin
                    next_state = G_ON_PERM;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd2) begin
                    next_state = G_OFF_PERM;
                    next_y_count = 2'd0;
                end else begin
                    next_state = G_ON_MONITOR_Y;
                    next_y_count = y_count + 1'b1;
                end

                // pattern_step irrelevant here
                next_pattern_step = 2'd0;
            end

            G_ON_PERM: begin
                // g=1 permanently until reset
                next_state = G_ON_PERM;
                next_pattern_step = 2'd0;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // g=0 permanently until reset
                next_state = G_OFF_PERM;
                next_pattern_step = 2'd0;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = A;
                next_pattern_step = 2'd0;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state
    assign f = (state == F_PULSE) ? 1'b1 : 1'b0;
    assign g = (state == G_ON_MONITOR_Y || state == G_ON_PERM) ? 1'b1 : 1'b0;

endmodule