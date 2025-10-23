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
    S_RESET,      // Reset state
    S_ACTIVE      // Active operation state
} state_t;

state_t current_state;

// Shift register for x sequence detection
reg [2:0] x_shift;
wire x_sequence_detected = (x_shift == 3'b101);

// Control signals
reg f_pulse;
reg g_active;
reg g_hold;
reg g_off;

// Shared counter
reg [1:0] counter;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= S_RESET;
        x_shift <= 3'b000;
        counter <= 2'b00;
        f_pulse <= 1'b0;
        g_active <= 1'b0;
        g_hold <= 1'b0;
        g_off <= 1'b0;
    end else begin
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        case (current_state)
            S_RESET: begin
                current_state <= S_ACTIVE;
                f_pulse <= 1'b1;
                counter <= 2'b01; // Single cycle for f pulse
            end
            
            S_ACTIVE: begin
                // Handle f pulse timing
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter == 1) f_pulse <= 1'b0;
                end
                
                // Sequence detection and g control
                if (x_sequence_detected && !g_active && !g_hold && !g_off) begin
                    g_active <= 1'b1;
                    counter <= 2'b10; // 2-cycle window for y
                end
                
                // y monitoring
                if (g_active) begin
                    if (y) begin
                        g_hold <= 1'b1;
                        g_active <= 1'b0;
                    end else if (counter == 0) begin
                        g_off <= 1'b1;
                        g_active <= 1'b0;
                    end
                end
            end
        endcase
    end
end

// Output generation
always @(*) begin
    if (!resetn) begin
        f = 1'b0;
        g = 1'b0;
    end else begin
        f = f_pulse;
        g = g_hold || (g_active && !g_off);
    end
end

endmodule