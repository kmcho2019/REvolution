module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define simplified states
typedef enum {
    STATE_A,
    STATE_MONITOR,
    STATE_CHECK_Y,
    STATE_G_HIGH,
    STATE_G_LOW
} state_t;

// State registers
state_t current_state, next_state;

// Pattern detection counter (counts 0-2 for 1-0-1 pattern)
reg [1:0] pattern_count;
reg [1:0] y_counter;

// State transition and output logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        f <= 0;
        g <= 0;
        pattern_count <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        
        // Output logic
        f <= (current_state == STATE_A && next_state == STATE_MONITOR);
        g <= (current_state == STATE_CHECK_Y || current_state == STATE_G_HIGH);
        
        // Pattern detection counter
        if (current_state == STATE_MONITOR) begin
            case (pattern_count)
                0: if (x) pattern_count <= 1;
                1: if (!x) pattern_count <= 2;
                2: if (x) pattern_count <= 3;
                default: pattern_count <= pattern_count;
            endcase
        end else begin
            pattern_count <= 0;
        end
        
        // Y monitoring counter
        if (current_state == STATE_CHECK_Y) begin
            y_counter <= y_counter + 1;
        end else begin
            y_counter <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_A: next_state = resetn ? STATE_MONITOR : STATE_A;
        STATE_MONITOR: next_state = (pattern_count == 3) ? STATE_CHECK_Y : STATE_MONITOR;
        STATE_CHECK_Y: begin
            if (y) next_state = STATE_G_HIGH;
            else if (y_counter == 2) next_state = STATE_G_LOW;
            else next_state = STATE_CHECK_Y;
        end
        STATE_G_HIGH, STATE_G_LOW: next_state = current_state;
        default: next_state = STATE_A;
    endcase
end

endmodule