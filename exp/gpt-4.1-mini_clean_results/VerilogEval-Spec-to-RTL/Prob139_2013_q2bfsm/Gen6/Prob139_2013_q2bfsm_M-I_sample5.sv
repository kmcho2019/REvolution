module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        STATE_A        = 3'd0, // reset/idle
        F_PULSE        = 3'd1, // f=1 one cycle after reset release
        PATTERN_DETECT = 3'd2, // detecting 1-0-1 on x
        MONITOR_Y      = 3'd3, // g=1, monitoring y for up to 2 cycles
        G_ON_PERM      = 3'd4, // permanent g=1
        G_OFF_PERM     = 3'd5  // permanent g=0
    } state_t;

    state_t state, next_state;

    // Pattern detection progress: counts matched bits (0 to 3)
    // 0 = no bits matched yet
    // Track 3 bits: 1,0,1
    logic [1:0] pattern_idx, pattern_idx_next;

    // y monitor count: counts how many cycles since asserting g=1
    logic [1:0] y_count, y_count_next;

    // Sequential logic: state, pattern_idx, y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            pattern_idx <= 2'd0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            pattern_idx <= pattern_idx_next;
            y_count <= y_count_next;
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // After one cycle with f=1, start pattern detection
                next_state = PATTERN_DETECT;
            end

            PATTERN_DETECT: begin
                if (pattern_idx == 2'd3) // pattern matched
                    next_state = MONITOR_Y;
                else
                    next_state = PATTERN_DETECT;
            end

            MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM; // y detected within 2 cycles
                else if (y_count == 2'd2)
                    next_state = G_OFF_PERM; // time expired without y=1
                else
                    next_state = MONITOR_Y;
            end

            G_ON_PERM: next_state = G_ON_PERM; // stay here until reset

            G_OFF_PERM: next_state = G_OFF_PERM; // stay here until reset

            default: next_state = STATE_A;
        endcase
    end

    // Combinational logic for pattern_idx_next
    always @(*) begin
        pattern_idx_next = 2'd0;
        case (state)
            PATTERN_DETECT: begin
                case (pattern_idx)
                    2'd0: pattern_idx_next = (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_idx_next = (x == 1'b0) ? 2'd2 :
                                             (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_idx_next = (x == 1'b1) ? 2'd3 :
                                             (x == 1'b1) ? 2'd1 : 2'd0; // second condition never true, fix next line
                    2'd3: pattern_idx_next = 2'd3; // stay at matched state until state change
                    default: pattern_idx_next = 2'd0;
                endcase
            end
            default: pattern_idx_next = 2'd0;
        endcase
    end

    // Fix the above duplicated condition in 2'd2 case:
    // It should be:
    // if x==1 -> 3 (pattern matched)
    // else if x==1 (again?) - this is duplicate and unreachable
    // else 0

    // So correct 2'd2 case:
    always @(*) begin
        if (state == PATTERN_DETECT) begin
            case (pattern_idx)
                2'd0: pattern_idx_next = (x == 1'b1) ? 2'd1 : 2'd0;
                2'd1: pattern_idx_next = (x == 1'b0) ? 2'd2 :
                                         (x == 1'b1) ? 2'd1 : 2'd0;
                2'd2: begin
                    if (x == 1'b1)
                        pattern_idx_next = 2'd3;
                    else if (x == 1'b1) // duplicate unreachable
                        pattern_idx_next = 2'd1;
                    else
                        pattern_idx_next = 2'd0;
                end
                2'd3: pattern_idx_next = 2'd3;
                default: pattern_idx_next = 2'd0;
            endcase
        end else begin
            pattern_idx_next = 2'd0;
        end
    end

    // The above still has the duplicate condition in 2'd2 case;
    // Let's rewrite to remove duplication:

    always @(*) begin
        if (state == PATTERN_DETECT) begin
            case (pattern_idx)
                2'd0: pattern_idx_next = (x == 1'b1) ? 2'd1 : 2'd0;
                2'd1: pattern_idx_next = (x == 1'b0) ? 2'd2 :
                                         (x == 1'b1) ? 2'd1 : 2'd0;
                2'd2: begin
                    if (x == 1'b1)
                        pattern_idx_next = 2'd3;    // pattern matched
                    else if (x == 1'b0)
                        pattern_idx_next = 2'd0;    // no match, reset
                    else
                        pattern_idx_next = 2'd0;    // default reset
                end
                2'd3: pattern_idx_next = 2'd3; // stay matched until next state
                default: pattern_idx_next = 2'd0;
            endcase
        end else begin
            pattern_idx_next = 2'd0;
        end
    end

    // Combinational logic for y_count_next
    always @(*) begin
        if (state == MONITOR_Y)
            y_count_next = y_count + 1'b1;
        else
            y_count_next = 2'd0;
    end

    // Output logic (Moore outputs) updated on clock edge
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