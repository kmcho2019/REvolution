module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// FSM states
typedef enum {
    IDLE,
    PULSE_F,
    WAIT_PATTERN,
    CHECK_Y
} state_t;

state_t current_state, next_state;

// Pattern detection shift register
reg [2:0] x_shift;
wire pattern_match = (x_shift == 3'b101);

// Timeout counter
reg [1:0] timeout_counter;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift <= 3'b0;
        timeout_counter <= 2'b0;
    end else begin
        current_state <= next_state;
        
        // Shift x input for pattern matching
        x_shift <= {x_shift[1:0], x};
        
        // Increment timeout counter in CHECK_Y state
        if (current_state == CHECK_Y && !y)
            timeout_counter <= timeout_counter + 1;
        else
            timeout_counter <= 2'b0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = resetn ? PULSE_F : IDLE;
        PULSE_F: next_state = WAIT_PATTERN;
        WAIT_PATTERN: next_state = pattern_match ? CHECK_Y : WAIT_PATTERN;
        CHECK_Y: next_state = CHECK_Y; // Permanent state until reset
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f is high only in PULSE_F state
        f <= (next_state == PULSE_F);
        
        // g control logic
        if (current_state == CHECK_Y) begin
            if (y)
                g <= 1'b1;  // Permanent g=1 if y=1
            else if (timeout_counter == 2'b10)
                g <= 1'b0;  // Permanent g=0 if timeout
        end else begin
            g <= 1'b0;
        end
    end
end

endmodule