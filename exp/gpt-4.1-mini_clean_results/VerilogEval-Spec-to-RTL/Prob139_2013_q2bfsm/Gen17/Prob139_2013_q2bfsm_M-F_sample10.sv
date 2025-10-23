module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // Main FSM state encoding
    typedef enum logic [3:0] {
        RESET        = 4'd0,
        F_PULSE      = 4'd1,
        PATTERN_WAIT = 4'd2,
        G_PULSE      = 4'd3,
        Y_WAIT_0     = 4'd4,
        Y_WAIT_1     = 4'd5,
        G_ON         = 4'd6,
        G_OFF        = 4'd7
    } state_t;

    state_t state, next_state;

    // Pattern detector internal states (track input x sequence 1,0,1)
    typedef enum logic [1:0] {
        P_WAIT_1  = 2'd0, // expect first 1
        P_WAIT_0  = 2'd1, // expect 0 after first 1
        P_WAIT_1F = 2'd2  // expect final 1 to complete pattern
    } pattern_state_t;

    pattern_state_t pstate, pstate_next;

    // Pattern detected flag
    wire pattern_detected;

    // Combinational logic for next pattern detector state
    always @(*) begin
        pstate_next = pstate;
        case(pstate)
            P_WAIT_1: begin
                if (x == 1'b1)
                    pstate_next = P_WAIT_0;
                else
                    pstate_next = P_WAIT_1;
            end
            P_WAIT_0: begin
                if (x == 1'b0)
                    pstate_next = P_WAIT_1F;
                else
                    pstate_next = P_WAIT_0;
            end
            P_WAIT_1F: begin
                if (x == 1'b1)
                    pstate_next = P_WAIT_1; // Pattern complete, restart detection
                else
                    pstate_next = P_WAIT_1;
            end
            default: pstate_next = P_WAIT_1;
        endcase
    end

    // Pattern detected on receiving the last 1 of 1,0,1 pattern
    assign pattern_detected = (pstate == P_WAIT_1F) && (x == 1'b1);

    // FSM sequential logic: state, pattern detector, and outputs update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= RESET;
            pstate <= P_WAIT_1;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Only update pattern detector state when in PATTERN_WAIT
            // Otherwise hold pattern state stable (do not reset)
            if (state == PATTERN_WAIT)
                pstate <= pstate_next;
            else
                pstate <= pstate;

            // Outputs synchronous and based on next_state
            // f is asserted only in F_PULSE state for one cycle
            // g asserted as per current FSM state
            case(next_state)
                F_PULSE: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case(next_state)
                G_PULSE: g <= 1'b1;
                Y_WAIT_0: g <= 1'b1;
                Y_WAIT_1: g <= 1'b1;
                G_ON: g <= 1'b1;
                default: g <= 1'b0;
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            RESET: begin
                // Hold while reset asserted; when deasserted move to F_PULSE
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // One cycle with f=1, then go to pattern wait
                next_state = PATTERN_WAIT;
            end

            PATTERN_WAIT: begin
                // Monitor x pattern with internal pattern FSM
                // Stay until pattern detected
                if (pattern_detected)
                    next_state = G_PULSE;
                else
                    next_state = PATTERN_WAIT;
            end

            G_PULSE: begin
                // One cycle asserting g=1, then start Y monitor
                next_state = Y_WAIT_0;
            end

            Y_WAIT_0: begin
                // Wait first cycle to detect y=1
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = Y_WAIT_1;
            end

            Y_WAIT_1: begin
                // Wait second cycle to detect y=1
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = G_OFF;
            end

            G_ON: begin
                // Permanently g=1 until reset
                next_state = G_ON;
            end

            G_OFF: begin
                // Permanently g=0 until reset
                next_state = G_OFF;
            end

            default: next_state = RESET;

        endcase
    end

endmodule