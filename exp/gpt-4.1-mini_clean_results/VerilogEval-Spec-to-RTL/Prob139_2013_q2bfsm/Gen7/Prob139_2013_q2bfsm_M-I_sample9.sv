module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (Moore FSM)
    typedef enum logic [2:0] {
        A              = 3'd0, // Reset / initial state
        F_PULSE        = 3'd1, // f=1 one cycle after reset deassert
        MONITOR_X      = 3'd2, // Monitor x for pattern 1,0,1
        G_ON_MONITOR_Y = 3'd3, // g=1, monitor y input for up to 2 cycles
        G_ON_PERM      = 3'd4, // g=1 permanently
        G_OFF_PERM     = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // To detect reset release event (resetn rising edge)
    reg resetn_d; // delayed resetn

    // Registered inputs to synchronize asynchronous inputs x and y
    reg x_d, y_d;

    // pattern_step encodes how many pattern bits matched for x pattern "1,0,1"
    // 0 = waiting for first '1'
    // 1 = got first '1', waiting for '0'
    // 2 = got '1','0', waiting for last '1'
    // 3 = pattern matched
    reg [1:0] pattern_step;

    // y_count counts how many cycles passed in G_ON_MONITOR_Y state (max 2)
    reg [1:0] y_count;

    // Sequential logic block: synchronize inputs, detect resetn rising edge,
    // update state, counters, and pattern_step
    always @(posedge clk) begin
        resetn_d <= resetn;    // delayed resetn for edge detection
        x_d <= x;
        y_d <= y;

        if (!resetn) begin
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
            f            <= 1'b0;
            g            <= 1'b0;
        end else begin
            state <= next_state;

            // Update pattern_step only in MONITOR_X state, else reset
            if (state == MONITOR_X) begin
                case (pattern_step)
                    2'd0: pattern_step <= (x_d == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x_d == 1'b0) ? 2'd2 :
                                          (x_d == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_step <= (x_d == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // hold matched pattern
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                pattern_step <= 2'd0;
            end

            // y_count increments only in G_ON_MONITOR_Y state, else reset
            if (state == G_ON_MONITOR_Y) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end

            // Update outputs f and g synchronously with state transitions,
            // following Moore FSM principle: outputs depend only on current state

            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                F_PULSE: begin
                    f <= 1'b1;  // f=1 exactly one clock cycle after resetn released
                    g <= 1'b0;
                end

                MONITOR_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                G_ON_MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;  // g=1 while monitoring y
                end

                G_ON_PERM: begin
                    f <= 1'b0;
                    g <= 1'b1;  // g=1 permanently
                end

                G_OFF_PERM: begin
                    f <= 1'b0;
                    g <= 1'b0;  // g=0 permanently
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        next_state = state; // default hold

        // Detect reset release event: resetn rising edge
        // This event triggers transition from A to F_PULSE on next clock
        // We use resetn_d (delayed resetn) to detect rising edge of resetn
        // reset_release = resetn & ~resetn_d;
        logic reset_release;
        reset_release = resetn & ~resetn_d;

        case (state)
            A: begin
                // Stay in A as long as resetn is low (asserted active low)
                // On reset release event, move to F_PULSE next clock
                if (reset_release)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After one cycle with f=1, go to pattern monitor
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                // When pattern_step == 3, pattern matched, move to monitoring y with g=1
                if (pattern_step == 2'd3) begin
                    next_state = G_ON_MONITOR_Y;
                end else begin
                    next_state = MONITOR_X;
                end
            end

            G_ON_MONITOR_Y: begin
                if (y_d == 1'b1) begin
                    // y detected within 2 cycles, stay g=1 forever
                    next_state = G_ON_PERM;
                end else if (y_count >= 2'd2) begin
                    // Timeout without seeing y=1, go g=0 permanently
                    next_state = G_OFF_PERM;
                end else begin
                    next_state = G_ON_MONITOR_Y;
                end
            end

            G_ON_PERM: begin
                // Hold g=1 until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Hold g=0 until reset
                next_state = G_OFF_PERM;
            end

            default: next_state = A;
        endcase
    end

endmodule