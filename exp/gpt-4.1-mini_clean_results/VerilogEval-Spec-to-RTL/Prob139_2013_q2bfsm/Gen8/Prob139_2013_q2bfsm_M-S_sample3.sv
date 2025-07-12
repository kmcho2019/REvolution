module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A_RESET     = 3'd0,
        PULSE_F     = 3'd1,
        WAIT_PATTERN= 3'd2,
        MONITOR_Y   = 3'd3,
        HOLD_G1     = 3'd4,
        HOLD_G0     = 3'd5
    } state_t;

    state_t state, next_state;

    // Shift register for last 3 x samples
    reg [2:0] x_shift;

    // Counter for monitoring y (0 to 2)
    reg [1:0] monitor_count;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A_RESET;
            x_shift <= 3'b000;
            monitor_count <= 2'b00;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x only if not in reset state
            if (state != A_RESET)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // Manage monitor_count only in MONITOR_Y, else zero
            if (state == MONITOR_Y)
                monitor_count <= monitor_count + 1'b1;
            else
                monitor_count <= 2'b00;

            // Moore output logic based on current state
            case (state)
                PULSE_F: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                HOLD_G1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                HOLD_G0: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    // A_RESET, WAIT_PATTERN
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            A_RESET: begin
                if (resetn)
                    next_state = PULSE_F;
            end

            PULSE_F: begin
                // After pulsing f for one cycle, start pattern detection
                next_state = WAIT_PATTERN;
            end

            WAIT_PATTERN: begin
                // Detect pattern 1-0-1 in x_shift
                if (x_shift == 3'b101)
                    next_state = MONITOR_Y;
            end

            MONITOR_Y: begin
                // If y == 1, hold g=1 forever
                if (y)
                    next_state = HOLD_G1;
                // Else if 2 cycles elapsed without y == 1, g=0 forever
                else if (monitor_count == 2'd2)
                    next_state = HOLD_G0;
            end

            HOLD_G1: begin
                // Stay here until reset
                if (!resetn)
                    next_state = A_RESET;
            end

            HOLD_G0: begin
                // Stay here until reset
                if (!resetn)
                    next_state = A_RESET;
            end

            default: next_state = A_RESET;
        endcase
    end

endmodule