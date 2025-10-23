module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    typedef enum logic [2:0] {
        RESET     = 3'd0,  // reset state, f=0, g=0
        PULSE_F   = 3'd1,  // f=1 for 1 cycle after reset release
        MONITOR_X = 3'd2,  // monitor x pattern with shift register
        PULSE_G   = 3'd3,  // g=1 for 1 cycle after pattern detected
        MONITOR_Y = 3'd4,  // monitor y for up to 2 cycles with g=1
        G_ON      = 3'd5,  // g=1 permanently
        G_OFF     = 3'd6   // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;    // shift register to hold last 3 x samples
    reg [1:0] y_count;    // count cycles in MONITOR_Y state

    // Sequential logic: state, shift register, counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= RESET;
            x_shift <= 3'b000;
            y_count <= 2'b00;
        end else begin
            state <= next_state;

            case (next_state)
                RESET: begin
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
                PULSE_F: begin
                    x_shift <= 3'b000;  // not monitoring x yet
                    y_count <= 2'b00;
                end
                MONITOR_X: begin
                    x_shift <= {x_shift[1:0], x};  // shift in new x
                    y_count <= 2'b00;
                end
                PULSE_G: begin
                    // keep x_shift, reset y_count for next stage
                    y_count <= 2'b00;
                end
                MONITOR_Y: begin
                    // x_shift unused here, hold value
                    y_count <= y_count + 1'b1;  // count cycles monitoring y
                end
                G_ON: begin
                    // hold values
                    y_count <= y_count;
                    x_shift <= x_shift;
                end
                G_OFF: begin
                    // hold values
                    y_count <= y_count;
                    x_shift <= x_shift;
                end
                default: begin
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            RESET: begin
                if (resetn)
                    next_state = PULSE_F;
                else
                    next_state = RESET;
            end
            PULSE_F: begin
                // one cycle f=1 pulse, then monitor x
                next_state = MONITOR_X;
            end
            MONITOR_X: begin
                // Wait for pattern 101 in x_shift
                if (x_shift == 3'b101)
                    next_state = PULSE_G;
                else
                    next_state = MONITOR_X;
            end
            PULSE_G: begin
                // one cycle g=1 pulse, then monitor y
                next_state = MONITOR_Y;
            end
            MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON;  // y=1 detected within 2 cycles
                else if (y_count == 2'd1)
                    // two cycles elapsed without y=1
                    next_state = G_OFF;
                else
                    next_state = MONITOR_Y;
            end
            G_ON: begin
                // permanent g=1 until reset
                next_state = G_ON;
            end
            G_OFF: begin
                // permanent g=0 until reset
                next_state = G_OFF;
            end
            default: next_state = RESET;
        endcase
    end

    // Moore outputs based on state
    assign f = (state == PULSE_F);
    assign g = (state == PULSE_G) || (state == MONITOR_Y) || (state == G_ON);

endmodule