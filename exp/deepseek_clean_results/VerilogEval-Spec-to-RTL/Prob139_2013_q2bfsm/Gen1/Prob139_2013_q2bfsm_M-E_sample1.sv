module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // States
    typedef enum logic [1:0] {
        IDLE,
        PATTERN_MATCH,
        DECISION
    } state_t;

    state_t current_state, next_state;

    // Counters and shift registers
    reg f_pulse_done;
    reg [2:0] x_pattern;
    reg [1:0] y_timeout;
    reg y_detected;

    // State transition
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= IDLE;
            f_pulse_done <= 0;
            x_pattern <= 3'b000;
            y_timeout <= 2'b00;
            y_detected <= 0;
        end else begin
            current_state <= next_state;
            
            // Update pattern shift register
            x_pattern <= {x_pattern[1:0], x};
            
            // Track f pulse completion
            if (current_state == IDLE && next_state == PATTERN_MATCH)
                f_pulse_done <= 1;
                
            // Track y timeout and detection
            if (current_state == PATTERN_MATCH && x_pattern == 3'b101) begin
                y_timeout <= 2'b00;
                y_detected <= 0;
            end else if (current_state == DECISION) begin
                y_timeout <= y_timeout + 1;
                if (y) y_detected <= 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = resetn ? PATTERN_MATCH : IDLE;
            PATTERN_MATCH: next_state = (x_pattern == 3'b101) ? DECISION : PATTERN_MATCH;
            DECISION: next_state = DECISION; // Terminal state until reset
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        f = (current_state == IDLE && resetn && !f_pulse_done);
        g = (current_state == DECISION) && 
            ((y_detected) || (y_timeout < 2'b10 && !y_detected));
    end

endmodule