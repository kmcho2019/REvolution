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
        A              = 3'd0, // Initial/reset state
        F_PULSE        = 3'd1, // f=1 for one cycle immediately after resetn deassert
        MONITOR_X      = 3'd2, // Monitor x pattern 1,0,1
        G_ON_MONITOR_Y = 3'd3, // g=1 and monitor y input for up to two cycles
        G_ON_PERM      = 3'd4, // g=1 permanently
        G_OFF_PERM     = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_step tracks progress in detecting pattern 1,0,1 on x
    // 0: waiting for first '1'
    // 1: matched first '1', waiting for '0'
    // 2: matched '1','0', waiting for last '1'
    // 3: pattern matched
    reg [1:0] pattern_step;

    // y_count counts cycles spent in G_ON_MONITOR_Y state
    reg [1:0] y_count;

    // Sequential logic: update state, pattern_step, y_count synchronously
    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset: initialize
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
        end else begin
            // Update pattern_step only in MONITOR_X
            if (state == MONITOR_X) begin
                // Pattern detection FSM to handle overlaps
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 :
                                         (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // Hold matched pattern until state changes
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                pattern_step <= 2'd0;
            end

            // Update y_count only in G_ON_MONITOR_Y
            if (state == G_ON_MONITOR_Y) begin
                // Count cycles 0,1,2 max
                if (y_count < 2'd2)
                    y_count <= y_count + 1'b1;
                else
                    y_count <= y_count;
            end else begin
                y_count <= 2'd0;
            end

            // Update state last to allow counters updated before next state use
            state <= next_state;
        end
    end

    // Combinational next state logic (depends on current state, inputs, updated counters)
    always @(*) begin
        next_state = state; // default hold

        case(state)
            A: begin
                // Stay in A while resetn==0; transition to F_PULSE when resetn==1
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After one cycle of f=1, move to monitor x
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                // Wait until pattern_step == 3 (pattern 1,0,1 matched)
                if (pattern_step == 2'd3)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end

            G_ON_MONITOR_Y: begin
                // g=1 here and monitor y input for up to 2 cycles
                if (y == 1'b1) begin
                    // y=1 within window → maintain g=1 permanently
                    next_state = G_ON_PERM;
                end else if (y_count >= 2'd2) begin
                    // y=1 not detected within two cycles → g=0 permanently
                    next_state = G_OFF_PERM;
                end else begin
                    // keep monitoring
                    next_state = G_ON_MONITOR_Y;
                end
            end

            G_ON_PERM: begin
                // g=1 permanently until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // g=0 permanently until reset
                next_state = G_OFF_PERM;
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs: depend only on current state
    assign f = (state == F_PULSE) ? 1'b1 : 1'b0;
    assign g = (state == G_ON_MONITOR_Y || state == G_ON_PERM) ? 1'b1 : 1'b0;

endmodule