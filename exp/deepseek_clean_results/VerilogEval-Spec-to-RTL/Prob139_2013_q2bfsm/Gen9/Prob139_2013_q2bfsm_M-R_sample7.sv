module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// FSM states
typedef enum logic [1:0] {
    RESET,
    PULSE_F,
    WAIT_PATTERN,
    MONITOR_Y
} state_t;

// Pattern detection shift register
reg [2:0] x_pattern;
always @(posedge clk) begin
    if (!resetn) x_pattern <= 3'b0;
    else x_pattern <= {x_pattern[1:0], x};
end

wire pattern_detected = (x_pattern == 3'b101);

// FSM registers
state_t state;
reg f_reg;
reg g_reg;
reg timeout;

// Timeout counter (1 bit = counts 0→1→2)
reg [1:0] y_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f_reg <= 0;
        g_reg <= 0;
        timeout <= 0;
        y_counter <= 0;
    end
    else begin
        case (state)
            RESET: begin
                f_reg <= 0;
                g_reg <= 0;
                if (resetn) state <= PULSE_F;
            end
            
            PULSE_F: begin
                f_reg <= 1;
                state <= WAIT_PATTERN;
            end
            
            WAIT_PATTERN: begin
                f_reg <= 0;
                if (pattern_detected) begin
                    g_reg <= 1;
                    state <= MONITOR_Y;
                    y_counter <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    // Permanent g=1
                    timeout <= 0;
                end
                else if (y_counter == 2'b10) begin
                    // Timeout - permanent g=0
                    g_reg <= 0;
                    timeout <= 1;
                end
                
                if (!timeout) y_counter <= y_counter + 1;
            end
        endcase
    end
end

// Output assignments
assign f = f_reg;
assign g = (state == MONITOR_Y && !timeout) ? 1'b1 : g_reg;

endmodule