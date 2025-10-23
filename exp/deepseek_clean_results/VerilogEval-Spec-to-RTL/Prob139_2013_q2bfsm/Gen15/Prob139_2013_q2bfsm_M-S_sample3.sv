module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// States
typedef enum logic [2:0] {
    IDLE,
    F_PULSE,
    MONITOR_X,
    MONITOR_Y,
    FINAL
} state_t;

reg [2:0] state, next_state;
reg [1:0] x_history;  // Stores last 2 x values
reg timeout;          // Single bit timeout counter

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 2'b0;
        timeout <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[0], x};
        
        // Timeout counter (only in MONITOR_Y state)
        timeout <= (state == MONITOR_Y) ? ~timeout : 0;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE:      if (resetn) next_state = F_PULSE;
        F_PULSE:   next_state = MONITOR_X;
        MONITOR_X: if (x_history == 2'b10 && x) next_state = MONITOR_Y;
        MONITOR_Y: begin
            if (y) next_state = FINAL;
            else if (timeout) next_state = FINAL;
        end
        FINAL:     next_state = FINAL;  // Stay until reset
    endcase
end

// Outputs
assign f = (state == F_PULSE);
assign g = (state == MONITOR_Y) || (state == FINAL && !timeout);

endmodule