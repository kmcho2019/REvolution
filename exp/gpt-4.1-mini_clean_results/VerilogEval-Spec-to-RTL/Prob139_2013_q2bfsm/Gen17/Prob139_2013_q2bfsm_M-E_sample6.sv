module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding: one-hot or binary encoding for clarity
    typedef enum reg [3:0] {
        S_RESET      = 4'd0, // state A: hold here while resetn=0, outputs f=0 g=0
        S_F_PULSE    = 4'd1, // state B: f=1 for one clock cycle
        S_X_WAIT_1   = 4'd2, // first bit pattern check x=1
        S_X_WAIT_0   = 4'd3, // second bit pattern check x=0
        S_X_WAIT_1B  = 4'd4, // third bit pattern check x=1
        S_G_PULSE    = 4'd5, // state D: g=1 pulse one clock cycle
        S_Y_MONITOR0 = 4'd6, // state E start monitoring y (count=0)
        S_Y_MONITOR1 = 4'd7, // state E count=1
        S_G_PERM_1   = 4'd8, // state F: g=1 permanent
        S_G_PERM_0   = 4'd9  // state G: g=0 permanent
    } state_t;

    state_t state, next_state;

    // To count monitoring cycles for y input (up to 2 cycles)
    reg [1:0] y_monitor_count;

    // Sampled inputs (registered)
    reg x_reg, y_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset
            state <= S_RESET;
            f <= 1'b0;
            g <= 1'b0;
            y_monitor_count <= 2'd0;
            x_reg <= 1'b0;
            y_reg <= 1'b0;
        end else begin
            // Sample inputs at clock
            x_reg <= x;
            y_reg <= y;

            // Update state and outputs on clock edge (Moore)
            state <= next_state;

            // Output logic based on state
            case (next_state)
                S_RESET: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                S_F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end

                S_X_WAIT_1,
                S_X_WAIT_0,
                S_X_WAIT_1B: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                S_G_PULSE: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                S_Y_MONITOR0,
                S_Y_MONITOR1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                S_G_PERM_1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                S_G_PERM_0: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase

            // y_monitor_count update only during y monitoring states
            if ((state == S_Y_MONITOR0 || state == S_Y_MONITOR1) && resetn) begin
                // increment count only if y not seen yet
                if (y_reg == 1'b0) begin
                    y_monitor_count <= y_monitor_count + 1'b1;
                end else begin
                    y_monitor_count <= 2'd0;
                end
            end else begin
                y_monitor_count <= 2'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case(state)
            S_RESET: begin
                if (resetn)
                    next_state = S_F_PULSE;
                else
                    next_state = S_RESET;
            end

            S_F_PULSE: begin
                // After one cycle pulse of f, start monitoring x for pattern bit 1
                next_state = S_X_WAIT_1;
            end

            // Pattern detection: waiting for first bit x=1
            S_X_WAIT_1: begin
                if (x_reg == 1'b1)
                    next_state = S_X_WAIT_0;
                else
                    next_state = S_X_WAIT_1; // stay, pattern not matched yet
            end

            // Waiting for second bit x=0
            S_X_WAIT_0: begin
                if (x_reg == 1'b0)
                    next_state = S_X_WAIT_1B;
                else if (x_reg == 1'b1)
                    // restart pattern detection as first bit matched again
                    next_state = S_X_WAIT_0; // Actually, better to restart to S_X_WAIT_1 if partial match lost
                    // to clarify: if x=1 here, we can restart from S_X_WAIT_1 because x=1 is first bit of pattern
                else
                    next_state = S_X_WAIT_1; // fallback to first bit wait on mismatch
            end

            // Waiting for third bit x=1
            S_X_WAIT_1B: begin
                if (x_reg == 1'b1)
                    next_state = S_G_PULSE;
                else if (x_reg == 1'b0)
                    next_state = S_X_WAIT_1; // mismatch, restart pattern detection
                else
                    next_state = S_X_WAIT_1; // default restart pattern detection
            end

            S_G_PULSE: begin
                // After one clock g=1 pulse, go to y monitoring start with count=0
                next_state = S_Y_MONITOR0;
            end

            // y monitoring state count=0
            S_Y_MONITOR0: begin
                if (y_reg == 1'b1)
                    next_state = S_G_PERM_1;
                else
                    next_state = S_Y_MONITOR1;
            end

            // y monitoring state count=1
            S_Y_MONITOR1: begin
                if (y_reg == 1'b1)
                    next_state = S_G_PERM_1;
                else
                    next_state = S_G_PERM_0; // y not detected within 2 cycles
            end

            S_G_PERM_1: begin
                // stay here until reset
                next_state = resetn ? S_G_PERM_1 : S_RESET;
            end

            S_G_PERM_0: begin
                // stay here until reset
                next_state = resetn ? S_G_PERM_0 : S_RESET;
            end

            default: begin
                next_state = S_RESET;
            end
        endcase
    end

endmodule