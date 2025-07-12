module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
typedef enum {
    RESET,
    F_PULSE,
    WAIT_X,
    MONITOR_Y,
    FINAL
} state_t;

state_t current_state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] y_timer;    // Counts cycles while monitoring y

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        f <= 0;
        g <= 0;
        x_history <= 3'b000;
        y_timer <= 2'b00;
    end else begin
        // Update x history
        x_history <= {x_history[1:0], x};
        
        case (current_state)
            RESET: begin
                f <= 0;
                g <= 0;
                x_history <= 3'b000;
                y_timer <= 2'b00;
                current_state <= F_PULSE;
            end
            
            F_PULSE: begin
                f <= 1;
                current_state <= WAIT_X;
            end
            
            WAIT_X: begin
                f <= 0;
                if (x_history == 3'b101) begin  // Detect 1-0-1 sequence
                    g <= 1;
                    y_timer <= 2'b00;  // Reset y monitoring timer
                    current_state <= MONITOR_Y;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    current_state <= FINAL;  // Keep g=1 permanently
                end else if (y_timer == 2'b01) begin  // After 2 cycles
                    g <= 0;
                    current_state <= FINAL;  // Keep g=0 permanently
                end
                y_timer <= y_timer + 1;  // Increment timer
            end
            
            FINAL: begin
                // Maintain outputs as is until reset
                f <= 0;
                // g remains at its current value
            end
        endcase
    end
end

endmodule