module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [3:0] {
        STATE_A = 4'd0,
        STATE_F1 = 4'd1,
        STATE_WAIT_X_1 = 4'd2,
        STATE_WAIT_X_0 = 4'd3,
        STATE_WAIT_X_1_AGAIN = 4'd4,
        STATE_G1 = 4'd5,
        STATE_MONITOR_Y_0 = 4'd6,
        STATE_MONITOR_Y_1 = 4'd7,
        STATE_G1_PERM = 4'd8,
        STATE_G0_PERM = 4'd9
    } state_t;

    reg [3:0] state, next_state;

    // Synchronous state transition and output logic
    always @(posedge clk) begin
        if (~resetn) begin
            state <= STATE_A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Default output values, overridden in next_state logic below
            f <= 1'b0;

            case (state)
                STATE_A: f <= 1'b0; // just a placeholder, f=0 while reset asserted
                STATE_F1: f <= 1'b1; // f=1 for one cycle
                default: f <= 1'b0;
            endcase

            // g is controlled by states with permanent values or single-cycle pulses
            // We'll set g in next_state block as well
        end
    end

    // Next state and output control combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;

        case(state)
            STATE_A: begin
                // Wait for reset de-assertion handled in sequential logic
                // When resetn de-asserted, next clock cycle FSM outputs f=1 (STATE_F1)
                // So next state moves to STATE_F1 when resetn is high
                if (resetn) begin
                    next_state = STATE_F1;
                end
                else begin
                    next_state = STATE_A;
                end
            end
            STATE_F1: begin
                // f=1 for one clock cycle then go to monitor x sequence starting with looking for x=1
                next_state = STATE_WAIT_X_1;
            end
            STATE_WAIT_X_1: begin
                // Waiting for x=1 (first bit in the sequence)
                if (x == 1'b1)
                    next_state = STATE_WAIT_X_0;
                else
                    next_state = STATE_WAIT_X_1; // stay waiting
            end
            STATE_WAIT_X_0: begin
                // Waiting for x=0 (second bit)
                if (x == 1'b0)
                    next_state = STATE_WAIT_X_1_AGAIN;
                else if (x == 1'b1)
                    next_state = STATE_WAIT_X_0; // still waiting for 0, but if x=1 again stay here to not lose sync
                else
                    next_state = STATE_WAIT_X_0; // stay here if x unknown (should not happen)
            end
            STATE_WAIT_X_1_AGAIN: begin
                // Waiting for x=1 (third bit)
                if (x == 1'b1)
                    next_state = STATE_G1; // sequence detected
                else if (x == 1'b0)
                    next_state = STATE_WAIT_X_1; // sequence broken, restart from first bit
                else
                    next_state = STATE_WAIT_X_1; // default to restart
            end
            STATE_G1: begin
                // Set g=1 for one cycle, then monitor y for up to two cycles
                next_state = STATE_MONITOR_Y_0;
            end
            STATE_MONITOR_Y_0: begin
                // first cycle of monitoring y
                if (y == 1'b1)
                    next_state = STATE_G1_PERM; // hold g=1 forever
                else
                    next_state = STATE_MONITOR_Y_1; // check again next cycle
            end
            STATE_MONITOR_Y_1: begin
                // second cycle monitoring y
                if (y == 1'b1)
                    next_state = STATE_G1_PERM; // hold g=1 forever
                else
                    next_state = STATE_G0_PERM; // g=0 permanently
            end
            STATE_G1_PERM: begin
                // hold g=1 forever until reset
                next_state = STATE_G1_PERM;
            end
            STATE_G0_PERM: begin
                // hold g=0 forever until reset
                next_state = STATE_G0_PERM;
            end
            default: begin
                next_state = STATE_A; // Safety default
            end
        endcase
    end

    // Output logic for g, synchronous with clock, depends on state
    always @(posedge clk) begin
        if (~resetn) begin
            g <= 1'b0;
        end else begin
            case(state)
                STATE_G1: g <= 1'b1;          // one cycle pulse
                STATE_G1_PERM: g <= 1'b1;     // hold 1 permanently
                STATE_G0_PERM: g <= 1'b0;     // hold 0 permanently
                default: g <= g;               // hold previous value
            endcase
        end
    end

endmodule