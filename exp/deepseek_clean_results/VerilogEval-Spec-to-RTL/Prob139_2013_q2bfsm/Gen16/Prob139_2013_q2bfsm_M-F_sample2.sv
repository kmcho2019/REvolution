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
    MONITOR_X,
    MONITOR_Y,
    DONE_G1,
    DONE_G0
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
                next_state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                f <= 1'b0;
                if (x_shift == 3'b101) begin
                    g <= 1'b1;
                    timeout_count <= 2'b00;
                    next_state <= MONITOR_Y;
                end else begin
                    g <= 1'b0;
                    next_state <= MONITOR_X;
                end
            end
            
            MONITOR_Y: begin
                f <= 1'b0;
                g <= 1'b1;
                
                if (y) begin
                    next_state <= DONE_G1;
                end else if (timeout_count == 2'b01) begin
                    next_state <= DONE_G0;
                end else begin
                    timeout_count <= timeout_count + 1;
                    next_state <= MONITOR_Y;
                end
            end
            
            DONE_G1: begin
                f <= 1'b0;
                g <= 1'b1;
                next_state <= DONE_G1;  // Stay here until reset
            end
            
            DONE_G0: begin
                f <= 1'b0;
                g <= 1'b0;
                next_state <= DONE_G0;  // Stay here until reset
            end
            
            default: next_state <= RESET;
        endcase
    end
end

endmodule