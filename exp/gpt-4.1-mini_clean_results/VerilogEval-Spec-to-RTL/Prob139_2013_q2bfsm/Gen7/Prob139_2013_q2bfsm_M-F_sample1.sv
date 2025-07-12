module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    localparam A              = 3'd0; // reset state
    localparam F_PULSE        = 3'd1; // f=1 for one cycle after reset de-asserted
    localparam MONITOR_X      = 3'd2; // monitor x for pattern 1,0,1
    localparam G_ON_MONITOR_Y = 3'd3; // g=1, monitor y for up to 2 cycles
    localparam G_ON_PERM      = 3'd4; // g=1 permanently
    localparam G_OFF_PERM     = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // pattern_step to track how much of the pattern 1,0,1 has matched
    // Use a 2-bit value:
    // 0: waiting for first '1'
    // 1: got first '1', waiting for '0'
    // 2: got '1','0', waiting for last '1'
    // 3: full pattern matched
    reg [1:0] pattern_step, next_pattern_step;

    // y_count counts how many cycles have passed monitoring y in G_ON_MONITOR_Y state
    // Counts 0,1,2 and transitions at exactly 2 cycles if y=0
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, pattern_step, y_count registers
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

    // Pattern matching logic - next_pattern_step computation
    // Handles overlapping pattern detection robustly
    always @(*) begin
        // Default next pattern_step hold current
        next_pattern_step = pattern_step;

        case (pattern_step)
            2'd0: begin
                // waiting for first '1'
                if (x == 1'b1)
                    next_pattern_step = 2'd1;
                else
                    next_pattern_step = 2'd0;
            end
            2'd1: begin
                // got first '1', waiting for '0'
                if (x == 1'b0)
                    next_pattern_step = 2'd2;
                else if (x == 1'b1)
                    // remain at step 1 if repeated '1' (start of pattern again)
                    next_pattern_step = 2'd1;
                else
                    next_pattern_step = 2'd0;
            end
            2'd2: begin
                // got '1','0', waiting for last '1'
                if (x == 1'b1)
                    next_pattern_step = 2'd3; // full pattern matched
                else if (x == 1'b0)
                    // restart pattern (waiting for first '1')
                    next_pattern_step = 2'd0;
                else
                    next_pattern_step = 2'd0;
            end
            2'd3: begin
                // pattern matched, hold here until transition out of MONITOR_X
                next_pattern_step = 2'd3;
            end
            default: next_pattern_step = 2'd0;
        endcase
    end

    // y_count next state logic
    // Increment count each cycle in G_ON_MONITOR_Y, else zero
    always @(*) begin
        if (state == G_ON_MONITOR_Y) begin
            if (y_count == 2'd2)
                next_y_count = y_count; // hold max count at 2
            else
                next_y_count = y_count + 1'b1;
        end else begin
            next_y_count = 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                // Remain in A while resetn is low
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end
            F_PULSE: begin
                // After one clock cycle f=1, go to MONITOR_X
                next_state = MONITOR_X;
            end
            MONITOR_X: begin
                // Wait for pattern_step == 3 (pattern matched)
                if (pattern_step == 2'd3)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end
            G_ON_MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count == 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end
            G_ON_PERM: begin
                // Remain here until reset
                next_state = G_ON_PERM;
            end
            G_OFF_PERM: begin
                // Remain here until reset
                next_state = G_OFF_PERM;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // Moore outputs depend on current state
    assign f = (state == F_PULSE) ? 1'b1 : 1'b0;
    assign g = (state == G_ON_MONITOR_Y || state == G_ON_PERM) ? 1'b1 : 1'b0;

endmodule