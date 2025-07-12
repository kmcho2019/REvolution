module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_A      = 3'd0, // Initial state (reset)
        STATE_F_PULSE= 3'd1, // f=1 for one cycle
        STATE_MON_X  = 3'd2, // Monitor x input for pattern 101
        STATE_G_PULSE= 3'd3, // g=1 for one cycle (pulse)
        STATE_MON_Y  = 3'd4, // Monitor y for up to 2 cycles
        STATE_G_ON   = 3'd5, // g=1 permanently
        STATE_G_OFF  = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;        // shift register to hold last 3 x samples
    reg       x_valid;        // set after collecting 3 samples for pattern detection
    reg [1:0] y_counter;      // counts cycles monitoring y input

    // State register and sequential logic with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            x_valid <= 1'b0;
            y_counter <= 2'b00;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Shift register update only in monitoring X state or STATE_F_PULSE (prepare)
            if (next_state == STATE_MON_X) begin
                x_shift <= {x_shift[1:0], x};
                // After shifting in 3 samples, set valid
                if (x_valid == 1'b0 && {x_shift[1:0], x} != 3'b000) begin
                    // On collecting 3 samples, mark valid
                    if (x_valid == 0)
                        x_valid <= 1'b1;
                end else
                    x_valid <= x_valid; // hold
            end else if (next_state == STATE_F_PULSE) begin
                // Reset shift register and valid when starting F pulse (after reset)
                x_shift <= 3'b000;
                x_valid <= 1'b0;
            end else if (next_state == STATE_A) begin
                // On reset, clear shift register and valid flag
                x_shift <= 3'b000;
                x_valid <= 1'b0;
            end

            // y_counter: count cycles monitoring y, reset when entering or leaving MON_Y
            if (next_state == STATE_MON_Y) begin
                if (state != STATE_MON_Y)
                    y_counter <= 2'd0; // reset counter at entry to MONITOR_Y
                else
                    y_counter <= y_counter + 1'b1;
            end else begin
                y_counter <= 2'd0; // reset outside MONITOR_Y
            end

            // Outputs: f and g as Moore outputs, updated at clock
            case (next_state)
                STATE_F_PULSE: f <= 1'b1;
                default:       f <= 1'b0;
            endcase

            case (next_state)
                STATE_G_PULSE,
                STATE_MON_Y,
                STATE_G_ON: g <= 1'b1;
                default:    g <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                if (resetn)
                    next_state = STATE_F_PULSE;
                else
                    next_state = STATE_A;
            end
            STATE_F_PULSE: begin
                // f=1 for one cycle, then start monitoring x
                next_state = STATE_MON_X;
            end
            STATE_MON_X: begin
                // Wait until x_valid is true and pattern 101 detected
                if (x_valid && (x_shift == 3'b101))
                    next_state = STATE_G_PULSE;
                else
                    next_state = STATE_MON_X;
            end
            STATE_G_PULSE: begin
                // g=1 one cycle pulse, then monitor y
                next_state = STATE_MON_Y;
            end
            STATE_MON_Y: begin
                // If y=1 detected, go to G_ON permanent g=1
                if (y == 1'b1)
                    next_state = STATE_G_ON;
                // else after two cycles without y=1, go G_OFF
                else if (y_counter == 2'd2)
                    next_state = STATE_G_OFF;
                else
                    next_state = STATE_MON_Y;
            end
            STATE_G_ON: begin
                // stay here forever until reset
                if (!resetn)
                    next_state = STATE_A;
                else
                    next_state = STATE_G_ON;
            end
            STATE_G_OFF: begin
                // stay here forever until reset
                if (!resetn)
                    next_state = STATE_A;
                else
                    next_state = STATE_G_OFF;
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule