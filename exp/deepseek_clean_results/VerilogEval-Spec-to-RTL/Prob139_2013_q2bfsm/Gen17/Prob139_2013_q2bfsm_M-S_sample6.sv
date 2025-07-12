module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// States
typedef enum logic [1:0] {
    IDLE,
    F_PULSE,
    MONITOR_X,
    FINAL
} state_t;

reg [1:0] state, next_state;
reg [1:0] x_history;  // Stores last 2 x values
reg timeout;          // Timeout counter for y detection
reg g_permanent;      // Permanent g value

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 2'b0;
        timeout <= 0;
        g_permanent <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[0], x};
        
        // Timeout counter (only in MONITOR_X after pattern detected)
        if (state == MONITOR_X && x_history == 2'b10 && x)
            timeout <= 1;
        else if (state == MONITOR_X && timeout)
            timeout <= 0;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE:      if (resetn) next_state = F_PULSE;
        F_PULSE:   next_state = MONITOR_X;
        MONITOR_X: begin
            if (x_history == 2'b10 && x) begin
                if (y) begin
                    next_state = FINAL;
                    g_permanent = 1;
                end
                else if (timeout) begin
                    next_state = FINAL;
                    g_permanent = 0;
                end
            end
        end
        FINAL:     next_state = FINAL;  // Stay until reset
    endcase
end

// Outputs
assign f = (state == F_PULSE);
assign g = (state == MONITOR_X && x_history == 2'b10 && x) || 
           (state == FINAL && g_permanent);

endmodule