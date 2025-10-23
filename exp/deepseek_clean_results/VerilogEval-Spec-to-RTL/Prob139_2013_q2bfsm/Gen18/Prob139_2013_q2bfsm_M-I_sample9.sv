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
    S_RESET,      // Waiting for reset release
    S_F_PULSE,    // Generate f=1 pulse
    S_WAIT_X,     // Waiting for x sequence
    S_G_ACTIVE,   // g=1, monitoring y
    S_G_HOLD,     // g=1 permanently
    S_G_OFF       // g=0 permanently
} state_t;

state_t current_state, next_state;
reg [1:0] x_history;  // Shift register for x sequence detection
reg [1:0] y_counter;  // Counter for y monitoring window

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= S_RESET;
        f <= 0;
        g <= 0;
        x_history <= 2'b00;
        y_counter <= 2'b00;
    end else begin
        // Update x history shift register
        x_history <= {x_history[0], x};
        
        case (current_state)
            S_RESET: begin
                f <= 0;
                g <= 0;
                next_state <= S_F_PULSE;
            end
            
            S_F_PULSE: begin
                f <= 1;
                next_state <= S_WAIT_X;
            end
            
            S_WAIT_X: begin
                f <= 0;
                // Check for 1-0-1 sequence (current x is 1, history is 0,1)
                if (x && x_history == 2'b01) begin
                    g <= 1;
                    y_counter <= 2'b10;  // Initialize 2-cycle counter
                    next_state <= S_G_ACTIVE;
                end else begin
                    next_state <= S_WAIT_X;
                end
            end
            
            S_G_ACTIVE: begin
                if (y) begin
                    next_state <= S_G_HOLD;
                end else if (y_counter > 0) begin
                    y_counter <= y_counter - 1;
                    next_state <= S_G_ACTIVE;
                end else begin
                    g <= 0;
                    next_state <= S_G_OFF;
                end
            end
            
            S_G_HOLD: begin
                g <= 1;
                next_state <= S_G_HOLD;
            end
            
            S_G_OFF: begin
                g <= 0;
                next_state <= S_G_OFF;
            end
            
            default: next_state <= S_RESET;
        endcase
    end
end

endmodule