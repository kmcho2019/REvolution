module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [3:0] {
        STATE_A  = 4'd0, // Reset active: f=0,g=0
        STATE_B  = 4'd1, // f=1 pulse (1 cycle after reset deassert)
        STATE_C0 = 4'd2, // Waiting for x=1 (start of pattern)
        STATE_C1 = 4'd3, // Got x=1, waiting for x=0
        STATE_C2 = 4'd4, // Got 1,0; waiting for x=1
        STATE_D  = 4'd5, // Pattern detected; g=1 pulse (1 cycle)
        STATE_E0 = 4'd6, // Monitor y cycle 1 with g=1
        STATE_E1 = 4'd7, // Monitor y cycle 2 with g=1
        STATE_F  = 4'd8, // Permanent g=1
        STATE_G  = 4'd9  // Permanent g=0
    } state_t;

    state_t state, next_state;

    reg [1:0] y_monitor_cnt; // Counts y monitoring cycles (0 or 1)

    // Sequential state and counters update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_monitor_cnt <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs assigned synchronously based on next state and inputs (Mealy logic for f)
            // f=1 only in STATE_B
            // g=1 in STATE_D, STATE_E0, STATE_E1, STATE_F

            // Update y monitoring counter in E states
            if (state == STATE_E0) begin
                y_monitor_cnt <= 2'd1; // after first monitoring cycle move to E1
            end else if (state == STATE_E1) begin
                y_monitor_cnt <= 2'd2; // second monitoring cycle done
            end else if ( (state != STATE_E0) && (state != STATE_E1) ) begin
                y_monitor_cnt <= 2'd0;
            end

            // Outputs updated
            f <= (next_state == STATE_B);
            g <= ( (next_state == STATE_D) || (next_state == STATE_E0) || (next_state == STATE_E1) || (next_state == STATE_F) );
        end
    end

    // Combinational next state logic
    always @(*) begin
        // Default next state hold
        next_state = state;

        case (state)
            STATE_A: begin
                // Stay in reset while resetn=0
                if (resetn)
                    next_state = STATE_B; // move out of reset and produce f=1 pulse
            end

            STATE_B: begin
                // After one cycle f=1, move to pattern detection initial state
                next_state = STATE_C0;
            end

            // Pattern detection as FSM states on x input:
            STATE_C0: begin
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0; // keep waiting
            end

            STATE_C1: begin
                if (x == 1'b0)
                    next_state = STATE_C2;
                else if (x == 1'b1)
                    next_state = STATE_C1; // stay if continuous 1's
                else
                    next_state = STATE_C0; // fallback if invalid
            end

            STATE_C2: begin
                if (x == 1'b1)
                    next_state = STATE_D; // pattern 1,0,1 detected
                else if (x == 1'b0)
                    next_state = STATE_C0; // restart pattern search
                else
                    next_state = STATE_C0;
            end

            STATE_D: begin
                // g=1 one cycle
                next_state = STATE_E0; // start monitoring y with g=1
            end

            // y monitoring window, at most two cycles with g=1
            STATE_E0: begin
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_E1; // continue monitoring second cycle
            end

            STATE_E1: begin
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_G; // permanent g=0 after timeout
            end

            STATE_F: begin
                // Permanent g=1 until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0 until reset
                next_state = STATE_G;
            end

            default: next_state = STATE_A; // safe default
        endcase
    end

endmodule