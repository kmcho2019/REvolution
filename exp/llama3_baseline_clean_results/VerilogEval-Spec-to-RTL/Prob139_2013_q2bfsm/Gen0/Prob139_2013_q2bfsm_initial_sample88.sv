module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enum for states
typedef enum logic [2:0] {
    STATE_A,       // Initial state, reset asserted
    STATE_SET_F,   // Set f to 1 for one cycle
    STATE_CHECK_X, // Check x for sequence 1, 0, 1
    STATE_WAIT_Y,  // Wait for y to be 1 within 2 cycles
    STATE_G_SET,   // g set permanently
    STATE_G_CLEAR  // g cleared permanently
} state_t;

state_t current_state, next_state;

reg [1:0] x_counter; // Counter for x sequence
reg [1:0] y_counter; // Counter for y wait

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            STATE_A: begin
                // Do nothing, stay in reset state
            end
            STATE_SET_F: begin
                f <= 1;
            end
            STATE_CHECK_X: begin
                if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0;
                end
            end
            STATE_WAIT_Y: begin
                if (y) begin
                    // y is 1, stay in this state and set g permanently
                    next_state <= STATE_G_SET;
                end else if (y_counter == 2) begin
                    // y did not become 1 within 2 cycles, clear g permanently
                    next_state <= STATE_G_CLEAR;
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            STATE_G_SET: begin
                // g is set, do nothing
            end
            STATE_G_CLEAR: begin
                // g is cleared, do nothing
            end
            default: begin
                // Should not reach here
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_SET_F;
            end
            f = 0;
            g = 0;
        end
        STATE_SET_F: begin
            next_state = STATE_CHECK_X;
            f = 1;
            g = 0;
        end
        STATE_CHECK_X: begin
            if (x_counter == 3) begin
                next_state = STATE_WAIT_Y;
            end else begin
                next_state = STATE_CHECK_X;
            end
            f = 0;
            g = 0;
        end
        STATE_WAIT_Y: begin
            next_state = STATE_WAIT_Y; // Default, might change in always block
            f = 0;
            g = 1;
        end
        STATE_G_SET: begin
            next_state = STATE_G_SET;
            f = 0;
            g = 1;
        end
        STATE_G_CLEAR: begin
            next_state = STATE_G_CLEAR;
            f = 0;
            g = 0;
        end
        default: begin
            next_state = STATE_A;
            f = 0;
            g = 0;
        end
    endcase
end

endmodule