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
    FINAL_G1,
    FINAL_G0
} state_t;

state_t current_state;
reg [2:0] x_shift;  // Shift register for x sequence
reg [1:0] y_timer;  // Timer for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b000;
        y_timer <= 2'b00;
    end else begin
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        case (current_state)
            RESET: begin
                f <= 0;
                g <= 0;
                x_shift <= 3'b000;
                y_timer <= 2'b00;
                current_state <= F_PULSE;
            end
            
            F_PULSE: begin
                f <= 1;
                current_state <= WAIT_X;
            end
            
            WAIT_X: begin
                f <= 0;
                if (x_shift == 3'b101) begin  // Detect 1-0-1 sequence
                    g <= 1;
                    y_timer <= 2'b10;  // Initialize 2-cycle timer
                    current_state <= MONITOR_Y;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    current_state <= FINAL_G1;
                end else begin
                    y_timer <= y_timer - 1;
                    if (y_timer == 2'b00) begin  // After 2 cycles
                        g <= 0;
                        current_state <= FINAL_G0;
                    end
                end
            end
            
            FINAL_G1: begin
                g <= 1;  // Maintain g=1 permanently
            end
            
            FINAL_G0: begin
                g <= 0;  // Maintain g=0 permanently
            end
        endcase
    end
end

endmodule