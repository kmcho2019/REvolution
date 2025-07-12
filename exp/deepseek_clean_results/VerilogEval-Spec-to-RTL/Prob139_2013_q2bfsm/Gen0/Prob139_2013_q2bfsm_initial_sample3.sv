module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum {
    STATE_A,
    STATE_F_PULSE,
    STATE_MONITOR_X,
    STATE_G_SET,
    STATE_CHECK_Y,
    STATE_G_HIGH,
    STATE_G_LOW
} state_t;

// State registers
state_t current_state, next_state;

// Pattern detection shift register
reg [2:0] x_pattern;

// Cycle counter for y monitoring
reg [1:0] y_counter;

// State transition and output logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        f <= 0;
        g <= 0;
        x_pattern <= 3'b0;
        y_counter <= 2'b0;
    end else begin
        current_state <= next_state;
        
        // Shift in new x value
        x_pattern <= {x_pattern[1:0], x};
        
        // Update outputs based on state
        case (current_state)
            STATE_A: begin
                f <= 0;
                g <= 0;
            end
            STATE_F_PULSE: begin
                f <= 1;
            end
            STATE_MONITOR_X: begin
                f <= 0;
            end
            STATE_G_SET: begin
                g <= 1;
                y_counter <= 2'b0;
            end
            STATE_CHECK_Y: begin
                y_counter <= y_counter + 1;
            end
            STATE_G_HIGH: begin
                g <= 1;
            end
            STATE_G_LOW: begin
                g <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_A: begin
            next_state = resetn ? STATE_F_PULSE : STATE_A;
        end
        STATE_F_PULSE: begin
            next_state = STATE_MONITOR_X;
        end
        STATE_MONITOR_X: begin
            if (x_pattern == 3'b101) begin
                next_state = STATE_G_SET;
            end else begin
                next_state = STATE_MONITOR_X;
            end
        end
        STATE_G_SET: begin
            next_state = STATE_CHECK_Y;
        end
        STATE_CHECK_Y: begin
            if (y) begin
                next_state = STATE_G_HIGH;
            end else if (y_counter == 2'b10) begin
                next_state = STATE_G_LOW;
            end else begin
                next_state = STATE_CHECK_Y;
            end
        end
        STATE_G_HIGH, STATE_G_LOW: begin
            next_state = current_state;  // Stay here until reset
        end
        default: begin
            next_state = STATE_A;
        end
    endcase
end

endmodule