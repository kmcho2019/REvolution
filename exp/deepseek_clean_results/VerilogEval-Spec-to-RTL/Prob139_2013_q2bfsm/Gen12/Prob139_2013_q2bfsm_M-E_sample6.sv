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
    RESET,
    INIT,
    MONITOR,
    FINAL
} state_t;

state_t current_state, next_state;

// Pattern detection
reg [2:0] x_history;
wire pattern_match = (x_history == 3'b101);

// Timeout counter
reg [1:0] timeout_counter;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_history <= 3'b0;
        timeout_counter <= 2'b0;
    end else begin
        current_state <= next_state;
        
        // Shift in new x value
        x_history <= {x_history[1:0], x};
        
        // Update timeout counter when in MONITOR state with pattern match
        if (current_state == MONITOR && pattern_match) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET:   next_state = resetn ? INIT : RESET;
        INIT:    next_state = MONITOR;
        MONITOR: begin
            if (pattern_match) begin
                if (y) begin
                    next_state = FINAL;
                end else if (timeout_counter == 2'b10) begin
                    next_state = FINAL;
                end else begin
                    next_state = MONITOR;
                end
            end else begin
                next_state = MONITOR;
            end
        end
        FINAL:   next_state = FINAL;
        default: next_state = RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f is high for one cycle after leaving RESET
        f <= (current_state == RESET && next_state == INIT);
        
        // g control logic
        if (current_state == FINAL) begin
            g <= (timeout_counter != 2'b10);  // g=1 if y was detected within 2 cycles
        end else begin
            g <= 1'b0;
        end
    end
end

endmodule