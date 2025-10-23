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
        RESET      = 4'd0,
        F_PULSE    = 4'd1,
        PATTERN_WAIT = 4'd2,
        G_PULSE    = 4'd3,
        Y_WAIT_0   = 4'd4,
        Y_WAIT_1   = 4'd5,
        G_ON       = 4'd6,
        G_OFF      = 4'd7
    } state_t;

    state_t state, next_state;

    // Pattern detector internal states
    typedef enum logic [1:0] {
        P_W1 = 2'd0, // expect first 1
        P_W0 = 2'd1, // expect 0 after 1
        P_W1F= 2'd2  // expect final 1
    } pattern_state_t;

    pattern_state_t pstate, pstate_next;

    // Flag indicating pattern detected in PATTERN_WAIT state
    wire pattern_detected;

    // Pattern detection combinational logic
    // Advances pattern FSM state with input x
    always @(*) begin
        pstate_next = pstate;
        case(pstate)
            P_W1: if (x == 1'b1) pstate_next = P_W0;
                  else             pstate_next = P_W1;
            P_W0: if (x == 1'b0) pstate_next = P_W1F;
                  else             pstate_next = P_W0;
            P_W1F: if (x == 1'b1) pstate_next = P_W1; // Pattern matched, restart detection
                   else            pstate_next = P_W1;
            default: pstate_next = P_W1;
        endcase
    end

    // Pattern detected if currently at P_W1F and x==1 (last bit matched)
    assign pattern_detected = (pstate == P_W1F) && (x == 1'b1);

    // Main FSM sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= RESET;
            pstate <= P_W1;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            pstate <= (state == PATTERN_WAIT) ? pstate_next : P_W1;

            // Outputs assigned combinationally below
            // so here we only update in sync with state
            // but keep this block for clock domain clarity
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case(state)
            RESET: begin
                // Hold here while reset asserted
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // Assert f=1 one cycle, then go to pattern wait
                f = 1'b1;
                next_state = PATTERN_WAIT;
            end

            PATTERN_WAIT: begin
                // Monitor pattern detector FSM
                g = 1'b0;
                f = 1'b0;
                if (pattern_detected)
                    next_state = G_PULSE;
                else
                    next_state = PATTERN_WAIT;
            end

            G_PULSE: begin
                // Assert g=1 one cycle, then start Y monitor 2-cycle timer
                g = 1'b1;
                next_state = Y_WAIT_0;
            end

            Y_WAIT_0: begin
                // g=1 while waiting max 2 cycles for y=1
                g = 1'b1;
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = Y_WAIT_1;
            end

            Y_WAIT_1: begin
                g = 1'b1;
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = G_OFF;
            end

            G_ON: begin
                // Hold g=1 permanently
                g = 1'b1;
                next_state = G_ON;
            end

            G_OFF: begin
                // Hold g=0 permanently
                g = 1'b0;
                next_state = G_OFF;
            end

            default: begin
                next_state = RESET;
            end
        endcase
    end

endmodule