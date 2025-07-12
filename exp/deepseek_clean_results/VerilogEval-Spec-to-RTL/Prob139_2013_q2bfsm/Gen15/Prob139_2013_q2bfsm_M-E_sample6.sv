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
    INITIAL_PULSE,
    MONITOR_X,
    MONITOR_Y
} state_t;

state_t current_state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;

// Timeout counter for y monitoring
reg [1:0] timeout_count;

// Permanent g register
reg g_permanent;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_shift <= 3'b000;
        timeout_count <= 2'b00;
        g_permanent <= 1'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        // State transitions
        case (current_state)
            RESET: begin
                f <= 1'b0;
                g <= 1'b0;
                next_state <= INITIAL_PULSE;
            end
            
            INITIAL_PULSE: begin
                f <= 1'b1;
                g <= 1'b0;
                next_state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                f <= 1'b0;
                g <= 1'b0;
                // Check for 1-0-1 pattern
                if (x_shift == 3'b101) begin
                    g <= 1'b1;
                    next_state <= MONITOR_Y;
                    timeout_count <= 2'b00;
                end
            end
            
            MONITOR_Y: begin
                f <= 1'b0;
                g <= 1'b1;
                
                if (y) begin
                    g_permanent <= 1'b1;
                    next_state <= MONITOR_X;  // Can go back to monitor x
                end else if (timeout_count == 2'b10) begin
                    g_permanent <= 1'b0;
                    next_state <= MONITOR_X;  // Can go back to monitor x
                end
                
                timeout_count <= timeout_count + 1;
            end
        endcase
        
        // Permanent g override
        if (g_permanent) g <= 1'b1;
    end
end

endmodule