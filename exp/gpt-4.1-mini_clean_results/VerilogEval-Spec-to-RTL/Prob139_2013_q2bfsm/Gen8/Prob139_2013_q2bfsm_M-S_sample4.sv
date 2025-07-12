module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    typedef enum logic [2:0] {
        A             = 3'd0, // Reset state
        F_PULSE       = 3'd1, // f=1 for one cycle after resetn de-assert
        WAIT_1        = 3'd2, // Waiting for x=1 (start pattern)
        WAIT_0        = 3'd3, // After x=1, waiting for x=0
        WAIT_1_FINAL  = 3'd4, // After x=0, waiting for final x=1
        MONITOR_Y     = 3'd5, // g=1, monitor y input up to 2 cycles
        G_ON_PERM     = 3'd6, // g=1 permanently
        G_OFF_PERM    = 3'd7  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Counter for monitoring y input in MONITOR_Y state (0..2)
    reg [1:0] y_count;

    // Sequential logic for state and y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == MONITOR_Y) begin
                if (y_count < 2'd2)
                    y_count <= y_count + 1'b1;
                else
                    y_count <= y_count;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // One cycle asserting f=1, then start pattern detection
                next_state = WAIT_1;
            end

            WAIT_1: begin
                if (x == 1'b1)
                    next_state = WAIT_0;
                else
                    next_state = WAIT_1;
            end

            WAIT_0: begin
                if (x == 1'b0)
                    next_state = WAIT_1_FINAL;
                else if (x == 1'b1)
                    next_state = WAIT_0; // stay waiting for 0, but remain here if still 1
                else
                    next_state = WAIT_1; // if x neither 1 nor 0 (shouldn't happen for 1-bit), fallback
            end

            WAIT_1_FINAL: begin
                if (x == 1'b1)
                    next_state = MONITOR_Y;
                else
                    next_state = WAIT_1; // restart pattern detection if mismatch
            end

            MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count >= 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = MONITOR_Y;
            end

            G_ON_PERM: begin
                next_state = G_ON_PERM; // stay here permanently
            end

            G_OFF_PERM: begin
                next_state = G_OFF_PERM; // stay here permanently
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs
    assign f = (state == F_PULSE) ? 1'b1 : 1'b0;
    assign g = (state == MONITOR_Y || state == G_ON_PERM) ? 1'b1 : 1'b0;

endmodule