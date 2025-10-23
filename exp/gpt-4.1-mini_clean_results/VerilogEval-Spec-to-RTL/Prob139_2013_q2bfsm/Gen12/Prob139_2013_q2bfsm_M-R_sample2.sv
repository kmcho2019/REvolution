module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State definitions
    typedef enum logic [2:0] {
        STATE_A       = 3'd0, // initial/reset state
        STATE_F       = 3'd1, // f=1 pulse state
        STATE_WAIT_X  = 3'd2, // wait for x pattern 101
        STATE_G_PULSE = 3'd3, // g=1 one cycle pulse after pattern
        STATE_Y_WAIT  = 3'd4, // wait up to 2 cycles for y=1
        STATE_G_ON    = 3'd5, // g=1 permanently
        STATE_G_OFF   = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // To detect pattern 101 on x in 3 consecutive cycles:
    // We store the previous two x inputs in regs prev_x1 and prev_x2:
    // pattern = {prev_x2, prev_x1, x} == 3'b101
    reg prev_x1, prev_x2, next_prev_x1, next_prev_x2;

    // y-monitoring counter (0,1,2)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state     <= STATE_A;
            prev_x1   <= 1'b0;
            prev_x2   <= 1'b0;
            y_count   <= 2'd0;
            f         <= 1'b0;
            g         <= 1'b0;
        end else begin
            state     <= next_state;
            prev_x1   <= next_prev_x1;
            prev_x2   <= next_prev_x2;
            y_count   <= next_y_count;
            f         <= (next_state == STATE_F);
            g         <= (next_state == STATE_G_PULSE) || (next_state == STATE_Y_WAIT) || (next_state == STATE_G_ON);
        end
    end

    // Combinational logic for next state and registers
    always @(*) begin
        // Default assignments to hold values
        next_state    = state;
        next_prev_x1  = prev_x1;
        next_prev_x2  = prev_x2;
        next_y_count  = y_count;

        case (state)
            STATE_A: begin
                // Stay here as long as reset asserted
                // On reset release, move to f pulse
                if (resetn)
                    next_state = STATE_F;
                else
                    next_state = STATE_A;
                // Clear registers on reset release
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end

            STATE_F: begin
                // f=1 for exactly one cycle, then move to wait pattern
                next_state   = STATE_WAIT_X;
                // Clear x pattern registers before start monitoring
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end

            STATE_WAIT_X: begin
                // Shift in x input: prev_x2 <= prev_x1, prev_x1 <= x
                next_prev_x2 = prev_x1;
                next_prev_x1 = x;

                // Check if pattern 101 detected on {prev_x2, prev_x1, x}
                if ({prev_x2, prev_x1, x} == 3'b101) begin
                    next_state = STATE_G_PULSE;
                    next_y_count = 2'd0;
                end else begin
                    next_state = STATE_WAIT_X;
                    next_y_count = 2'd0;
                end
            end

            STATE_G_PULSE: begin
                // g=1 one cycle, then go to y monitor
                next_state = STATE_Y_WAIT;
                // Clear previous x registers (no longer needed)
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end

            STATE_Y_WAIT: begin
                // Keep g=1, wait for y=1 up to 2 cycles
                if (y == 1'b1) begin
                    next_state = STATE_G_ON;    // y=1 detected: g=1 permanently
                    next_y_count = 2'd0;
                end else if (y_count == 2'd2) begin
                    // Timeout after two cycles without y=1
                    next_state = STATE_G_OFF;   // g=0 permanently
                    next_y_count = 2'd0;
                end else begin
                    // Increment y counter and keep waiting
                    next_y_count = y_count + 1'b1;
                    next_state = STATE_Y_WAIT;
                end
                // Clear x registers
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
            end

            STATE_G_ON: begin
                // g=1 permanently until reset
                next_state = STATE_G_ON;
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end

            STATE_G_OFF: begin
                // g=0 permanently until reset
                next_state = STATE_G_OFF;
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = STATE_A;
                next_prev_x1 = 1'b0;
                next_prev_x2 = 1'b0;
                next_y_count = 2'd0;
            end
        endcase
    end

endmodule