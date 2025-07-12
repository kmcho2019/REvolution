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
        A             = 3'd0, // Reset or start state
        F_PULSE       = 3'd1, // Assert f=1 for exactly one cycle after reset deassert
        MONITOR_X     = 3'd2, // Monitor x pattern 1,0,1
        G_ON_MONITOR_Y= 3'd3, // g=1 and monitor y up to 2 cycles
        G_ON_PERM     = 3'd4, // g=1 permanently
        G_OFF_PERM    = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_step tracks the progress in matching x pattern: 0..3
    reg [1:0] pattern_step;

    // y_count counts cycles in G_ON_MONITOR_Y state, from 0 up to 2
    reg [1:0] y_count;

    // Sequential logic: state and counters update on posedge clk
    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous active-low reset: go to state A and reset counters
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
        end else begin
            state <= next_state;

            // Update pattern_step only in MONITOR_X state
            if (state == MONITOR_X) begin
                // Pattern to detect on x is 1,0,1 in successive clocks
                // pattern_step tracks how many pattern bits matched so far
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 :
                                         (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // pattern matched, hold here
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                // Reset pattern_step if not in MONITOR_X
                pattern_step <= 2'd0;
            end

            // Update y_count only in G_ON_MONITOR_Y
            if (state == G_ON_MONITOR_Y) begin
                // Count cycles up to 2 (0,1,2) then transitions on next_state logic
                if (y_count < 2'd2)
                    y_count <= y_count + 1'b1;
                else
                    y_count <= y_count; // hold max count if any
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Combinational next_state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                // Stay in A while resetn==0,
                // move to F_PULSE on first clock after resetn==1
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // f=1 for one clock cycle only, then start monitoring x
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                // Wait until pattern_step==3 (pattern matched)
                if (pattern_step == 2'd3)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end

            G_ON_MONITOR_Y: begin
                // g=1 here and monitor y input for up to two clock cycles
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count >= 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end

            G_ON_PERM: begin
                // Maintain g=1 permanently
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Maintain g=0 permanently
                next_state = G_OFF_PERM;
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs depend only on current state
    assign f = (state == F_PULSE) ? 1'b1 : 1'b0;
    assign g = (state == G_ON_MONITOR_Y || state == G_ON_PERM) ? 1'b1 : 1'b0;

endmodule