module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [2:0] {
    RESET,
    PULSE_F,
    WAIT_FOR_PATTERN,
    MONITOR_Y,
    G_PERMANENT_HIGH,
    G_PERMANENT_LOW
} state_t;

state_t current_state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;

// Timeout counter for y monitoring
reg [1:0] timeout_count;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_shift <= 3'b000;
        timeout_count <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        case (current_state)
            RESET: begin
                f <= 1'b0;
                g <= 1'b0;
                next_state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1'b1;
                g <= 1'b0;
                next_state <= WAIT_FOR_PATTERN;
            end
            
            WAIT_FOR_PATTERN: begin
                f <= 1'b0;
                g <= 1'b0;
                if (x_shift == 3'b101) begin
                    g <= 1'b1;
                    timeout_count <= 2'b00;
                    next_state <= MONITOR_Y;
                end
            end
            
            MONITOR_Y: begin
                f <= 1'b0;
                g <= 1'b1;
                
                if (y) begin
                    next_state <= G_PERMANENT_HIGH;
                end else if (timeout_count == 2'b01) begin
                    next_state <= G_PERMANENT_LOW;
                end
                
                timeout_count <= timeout_count + 1;
            end
            
            G_PERMANENT_HIGH: begin
                f <= 1'b0;
                g <= 1'b1;
                // Stay here until reset
            end
            
            G_PERMANENT_LOW: begin
                f <= 1'b0;
                g <= 1'b0;
                // Stay here until reset
            end
            
            default: next_state <= RESET;
        endcase
    end
end

endmodule