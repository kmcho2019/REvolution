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
        
        case (current_state)
            RESET: begin
                f <= 1'b0;
                g <= 1'b0;
                next_state <= PULSE_F;
                x_shift <= 3'b000;
            end
            
            PULSE_F: begin
                f <= 1'b1;
                g <= 1'b0;
                next_state <= WAIT_FOR_PATTERN;
                x_shift <= {x_shift[1:0], x};
            end
            
            WAIT_FOR_PATTERN: begin
                f <= 1'b0;
                g <= 1'b0;
                x_shift <= {x_shift[1:0], x};
                
                if (x_shift == 3'b101) begin
                    next_state <= MONITOR_Y;
                    timeout_count <= 2'b00;
                end else begin
                    next_state <= WAIT_FOR_PATTERN;
                end
            end
            
            MONITOR_Y: begin
                f <= 1'b0;
                g <= 1'b1;
                
                if (y) begin
                    next_state <= G_PERMANENT_HIGH;
                end else if (timeout_count == 2'd1) begin
                    next_state <= G_PERMANENT_LOW;
                end else begin
                    timeout_count <= timeout_count + 1;
                    next_state <= MONITOR_Y;
                end
                
                x_shift <= {x_shift[1:0], x};
            end
            
            G_PERMANENT_HIGH: begin
                f <= 1'b0;
                g <= 1'b1;
                next_state <= G_PERMANENT_HIGH;
            end
            
            G_PERMANENT_LOW: begin
                f <= 1'b0;
                g <= 1'b0;
                next_state <= G_PERMANENT_LOW;
            end
            
            default: begin
                next_state <= RESET;
            end
        endcase
    end
end

endmodule