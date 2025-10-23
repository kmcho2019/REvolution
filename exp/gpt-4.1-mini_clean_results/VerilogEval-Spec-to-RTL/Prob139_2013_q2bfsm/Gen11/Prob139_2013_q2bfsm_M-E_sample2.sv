module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A_WAIT_RESET = 3'd0,  // waiting while reset asserted
        A_F_PULSE    = 3'd1,  // f=1 for 1 cycle after reset release
        B_PATTERN    = 3'd2,  // monitoring x input for pattern 1,0,1
        C_G_PULSE    = 3'd3,  // g=1 for 1 cycle after pattern detection
        D_Y_MONITOR  = 3'd4,  // g=1, monitoring y input for up to 2 cycles
        E_G_ON_PERM  = 3'd5,  // g=1 permanently
        F_G_OFF_PERM = 3'd6   // g=0 permanently
    } state_t;

    reg [2:0] state, next_state;

    // For pattern detection, keep track of last two x inputs
    // x_prev2 is oldest, x_prev1 is middle, x current is newest
    reg x_prev2, x_prev1;

    // y_monitor_counter counts how many clock cycles have been spent in D_Y_MONITOR state
    reg [1:0] y_monitor_counter, next_y_monitor_counter;

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A_WAIT_RESET;
            x_prev2 <= 1'b0;
            x_prev1 <= 1'b0;
            y_monitor_counter <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Update previous x samples only in pattern monitoring and forward states
            // We'll update x_prev2 and x_prev1 in states where pattern is relevant (B_PATTERN)
            if (state == B_PATTERN) begin
                x_prev2 <= x_prev1;
                x_prev1 <= x;
            end else begin
                // Hold values in other states - pattern matching irrelevant
                x_prev2 <= x_prev2;
                x_prev1 <= x_prev1;
            end

            // Update y_monitor_counter when in D_Y_MONITOR state
            y_monitor_counter <= next_y_monitor_counter;

            // Outputs f and g assigned combinationally below
            f <= (next_state == A_F_PULSE);
            g <= (next_state == C_G_PULSE) || (next_state == D_Y_MONITOR) || (next_state == E_G_ON_PERM);
        end
    end

    // Next state and counter logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_y_monitor_counter = y_monitor_counter;

        case (state)

            A_WAIT_RESET: begin
                if (resetn)
                    next_state = A_F_PULSE;
                else
                    next_state = A_WAIT_RESET;
                // no counters update here
                next_y_monitor_counter = 2'd0;
            end

            A_F_PULSE: begin
                // f=1 for exactly one cycle, then proceed to pattern monitor
                next_state = B_PATTERN;
                next_y_monitor_counter = 2'd0;
            end

            B_PATTERN: begin
                // Update pattern by comparing {x_prev2,x_prev1,x}
                // Pattern to detect: 1,0,1

                // Note: x_prev2 is oldest, x_prev1 middle, x current newest
                if ({x_prev2,x_prev1,x} == 3'b101) begin
                    // Pattern detected
                    next_state = C_G_PULSE;
                    next_y_monitor_counter = 2'd0;
                end else begin
                    // Continue pattern detection
                    next_state = B_PATTERN;
                    next_y_monitor_counter = 2'd0;
                end
            end

            C_G_PULSE: begin
                // g=1 for exactly one cycle, then start y monitoring
                next_state = D_Y_MONITOR;
                next_y_monitor_counter = 2'd0;
            end

            D_Y_MONITOR: begin
                // g=1, monitoring y for up to 2 cycles
                if (y == 1'b1) begin
                    // y=1 detected, latch g=1 permanently
                    next_state = E_G_ON_PERM;
                    next_y_monitor_counter = 2'd0;
                end else if (y_monitor_counter == 2'd1) begin
                    // We've waited 2 cycles already (counter started at 0),
                    // y not seen, latch g=0 permanently
                    next_state = F_G_OFF_PERM;
                    next_y_monitor_counter = 2'd0;
                end else begin
                    // keep monitoring
                    next_state = D_Y_MONITOR;
                    next_y_monitor_counter = y_monitor_counter + 1'b1;
                end
            end

            E_G_ON_PERM: begin
                // g=1 permanently until reset
                next_state = E_G_ON_PERM;
                next_y_monitor_counter = 2'd0;
            end

            F_G_OFF_PERM: begin
                // g=0 permanently until reset
                next_state = F_G_OFF_PERM;
                next_y_monitor_counter = 2'd0;
            end

            default: begin
                next_state = A_WAIT_RESET;
                next_y_monitor_counter = 2'd0;
            end

        endcase
    end

endmodule