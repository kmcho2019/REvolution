module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM state encoding
    typedef enum reg [1:0] {
        S_F_PULSE = 2'd0, // pulse f for 1 cycle after reset
        S_WAIT_X  = 2'd1, // monitor x input for pattern 1,0,1
        S_G_PULSE = 2'd2, // pulse g for 1 cycle after pattern detected
        S_Y_WAIT  = 2'd3  // wait up to 2 cycles for y=1, then hold g accordingly
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;        // shift register for x samples
    reg [1:0] y_timer;        // counts cycles for y monitoring
    reg       g_permanent;    // 1 = keep g=1 permanently; 0 = keep g=0 permanently

    // Sequential logic: state, x_shift, timer, g_permanent
    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous reset: reset all to initial conditions
            state       <= S_F_PULSE;
            x_shift     <= 3'b000;
            y_timer     <= 2'd0;
            g_permanent <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                S_F_PULSE: begin
                    // On pulse state, clear shift register and y_timer
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                    g_permanent <= 1'b0; // reset g_permanent at start
                end
                S_WAIT_X: begin
                    // Shift in newest x at LSB, oldest at MSB
                    x_shift <= {x_shift[1:0], x};
                    // y_timer and g_permanent unchanged here
                end
                S_G_PULSE: begin
                    // On g pulse cycle, keep all else steady
                    x_shift <= x_shift; // no change
                    y_timer <= 2'd0;    // reset timer for y monitoring
                    g_permanent <= 1'b0;
                end
                S_Y_WAIT: begin
                    // In Y wait state, count cycles up to 2 while monitoring y
                    if (!g_permanent) begin
                        if (y == 1'b1) begin
                            g_permanent <= 1'b1; // hold g=1 permanently
                            y_timer <= y_timer;  // hold timer
                        end else if (y_timer < 2) begin
                            y_timer <= y_timer + 1'b1;
                        end else begin
                            // after 2 cycles without y=1
                            g_permanent <= 1'b0;
                            y_timer <= y_timer; // hold timer at 2
                        end
                    end else begin
                        // g_permanent already set: hold g=1
                        g_permanent <= 1'b1;
                        y_timer <= y_timer; // hold timer
                    end
                    // x_shift not used here, no update
                end
                default: begin
                    // Should never happen, reset state and regs
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                    g_permanent <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S_F_PULSE: begin
                // After one cycle pulse of f, go to wait x pattern detection
                next_state = S_WAIT_X;
            end
            S_WAIT_X: begin
                // Check for pattern x=1,0,1 on x_shift (MSB oldest)
                if (x_shift == 3'b101)
                    next_state = S_G_PULSE;
                else
                    next_state = S_WAIT_X;
            end
            S_G_PULSE: begin
                // After one cycle pulse of g, go to y wait
                next_state = S_Y_WAIT;
            end
            S_Y_WAIT: begin
                // Stay here permanently after g pulse
                next_state = S_Y_WAIT;
            end
            default: begin
                next_state = S_F_PULSE;
            end
        endcase
    end

    // Output logic based only on current state and g_permanent (registered signals)
    always @(*) begin
        // default values
        f = 1'b0;
        g = 1'b0;

        case (state)
            S_F_PULSE: f = 1'b1; // pulse f for one cycle
            S_G_PULSE: g = 1'b1; // pulse g for one cycle
            S_Y_WAIT:  g = g_permanent; // hold g as per permanent flag
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule