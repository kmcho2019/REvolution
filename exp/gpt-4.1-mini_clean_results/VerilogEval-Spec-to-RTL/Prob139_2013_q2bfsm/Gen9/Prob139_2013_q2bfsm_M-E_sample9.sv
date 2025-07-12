module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum reg [3:0] {
        A_RESET     = 4'd0,
        PULSE_F     = 4'd1,
        WAIT_X1     = 4'd2,
        WAIT_X0     = 4'd3,
        WAIT_X2     = 4'd4,
        MONITOR_Y_1 = 4'd5,
        MONITOR_Y_2 = 4'd6,
        HOLD_G1     = 4'd7,
        HOLD_G0     = 4'd8
    } state_t;

    state_t state, next_state;

    // Sequential state update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A_RESET;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        next_state = state;

        case(state)
            A_RESET: begin
                // Stay here while reset asserted
                // On release, go to PULSE_F next cycle
                if (resetn)
                    next_state = PULSE_F;
            end

            PULSE_F: begin
                // Pulse f=1 for this cycle
                f = 1'b1;
                g = 1'b0;
                // Next state: wait for x=1 to start sequence
                next_state = WAIT_X1;
            end

            WAIT_X1: begin
                // f=0,g=0 default
                // Wait for x=1 to start pattern detection
                // Stay until x=1 seen
                if (x == 1'b1)
                    next_state = WAIT_X0;
            end

            WAIT_X0: begin
                // Wait for x=0 after seeing 1
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else if (x == 1'b1)
                    next_state = WAIT_X0; // Remain here if x=1, pattern broken, restart from WAIT_X0
                else
                    next_state = WAIT_X1; // if anything else (shouldn't happen) restart
            end

            WAIT_X2: begin
                // Wait for final x=1 to complete 1-0-1
                if (x == 1'b1)
                    next_state = MONITOR_Y_1;
                else if (x == 1'b0)
                    next_state = WAIT_X1; // pattern broken, restart sequence
                else
                    next_state = WAIT_X1; // conservative restart
            end

            MONITOR_Y_1: begin
                // g=1 while monitoring y
                g = 1'b1;
                // Check y this cycle
                if (y == 1'b1)
                    next_state = HOLD_G1;    // y detected immediately, hold g=1 forever
                else
                    next_state = MONITOR_Y_2; // wait one more cycle
            end

            MONITOR_Y_2: begin
                g = 1'b1;
                if (y == 1'b1)
                    next_state = HOLD_G1;    // y detected within 2 cycles, hold g=1
                else
                    next_state = HOLD_G0;    // y not detected within 2 cycles, hold g=0 forever
            end

            HOLD_G1: begin
                g = 1'b1;
                // Wait here until reset
                if (!resetn)
                    next_state = A_RESET;
            end

            HOLD_G0: begin
                g = 1'b0;
                // Wait here until reset
                if (!resetn)
                    next_state = A_RESET;
            end

            default: begin
                // Safe fallback
                next_state = A_RESET;
            end
        endcase
    end

endmodule