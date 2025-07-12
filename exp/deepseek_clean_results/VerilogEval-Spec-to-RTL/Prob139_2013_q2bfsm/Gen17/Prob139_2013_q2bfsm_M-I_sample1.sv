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
    S_RESET,    // Waiting for reset release
    S_F_PULSE,  // Generate f=1 pulse
    S_IDLE,     // Waiting for x sequence
    S_X1,       // First '1' in sequence detected
    S_X0,       // '0' in sequence detected
    S_X1_FINAL, // Final '1' in sequence detected
    S_G_ON,     // g=1, monitoring y
    S_G_WAIT,   // First wait cycle for y
    S_G_HOLD,   // g=1 permanently
    S_G_OFF     // g=0 permanently
} state_t;

state_t current_state, next_state;
reg [1:0] y_timer;  // Counts cycles in y monitoring phase

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= S_RESET;
        f <= 0;
        g <= 0;
        y_timer <= 0;
    end else begin
        current_state <= next_state;
        
        // Default outputs
        f <= 0;
        g <= 0;
        
        case (current_state)
            S_RESET: begin
                // Stay in reset until resetn goes high
                next_state <= S_F_PULSE;
            end
            
            S_F_PULSE: begin
                f <= 1;
                next_state <= S_IDLE;
            end
            
            S_IDLE: begin
                if (x) next_state <= S_X1;
                else next_state <= S_IDLE;
            end
            
            S_X1: begin
                if (!x) next_state <= S_X0;
                else next_state <= S_X1;  // Stay if x remains 1
            end
            
            S_X0: begin
                if (x) next_state <= S_X1_FINAL;
                else next_state <= S_IDLE;  // Sequence broken
            end
            
            S_X1_FINAL: begin
                g <= 1;
                y_timer <= 2'b10;  // Initialize 2-cycle counter
                next_state <= S_G_ON;
            end
            
            S_G_ON: begin
                g <= 1;
                if (y) begin
                    next_state <= S_G_HOLD;
                end else if (y_timer > 0) begin
                    y_timer <= y_timer - 1;
                    next_state <= S_G_WAIT;
                end else begin
                    next_state <= S_G_OFF;
                end
            end
            
            S_G_WAIT: begin
                g <= 1;
                if (y) begin
                    next_state <= S_G_HOLD;
                end else begin
                    next_state <= S_G_OFF;
                end
            end
            
            S_G_HOLD: begin
                g <= 1;
                next_state <= S_G_HOLD;  // Stay permanently
            end
            
            S_G_OFF: begin
                g <= 0;
                next_state <= S_G_OFF;   // Stay permanently
            end
            
            default: next_state <= S_RESET;
        endcase
    end
end

endmodule