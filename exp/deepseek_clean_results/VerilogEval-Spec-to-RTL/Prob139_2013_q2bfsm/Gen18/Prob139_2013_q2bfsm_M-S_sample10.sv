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
    MONITOR,
    FINAL
} state_t;

reg [1:0] state, next_state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] timeout;    // Timeout counter for y detection
reg g_value;          // Permanent g value

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 3'b0;
        timeout <= 2'b0;
        g_value <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};
        
        // Timeout counter (only in MONITOR after pattern detected)
        if (state == MONITOR && x_history == 3'b101) begin
            timeout <= 2'b10;  // Initialize to 2 (counts down)
        end else if (timeout > 0) begin
            timeout <= timeout - 1;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    g_value = 0;
    
    case (state)
        IDLE: begin
            if (resetn) next_state = MONITOR;
        end
        MONITOR: begin
            if (x_history == 3'b101) begin
                if (y) begin
                    next_state = FINAL;
                    g_value = 1;
                end else if (timeout == 0) begin
                    next_state = FINAL;
                    g_value = 0;
                end
            end
        end
        FINAL: begin
            g_value = g_value;  // Maintain previous value
        end
    endcase
end

// Outputs
assign f = (state == IDLE && resetn);  // Pulse f for one cycle after reset
assign g = (state == MONITOR && x_history == 3'b101) || 
           (state == FINAL && g_value);

endmodule