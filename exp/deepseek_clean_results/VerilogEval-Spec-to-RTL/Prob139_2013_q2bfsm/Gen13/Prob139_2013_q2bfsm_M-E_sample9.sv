module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding (one-hot)
localparam STATE_A      = 3'b001;
localparam STATE_F_PULSE = 3'b010;
localparam STATE_MONITOR = 3'b100;

reg [2:0] current_state, next_state;
reg [1:0] x_history;  // Stores last two x values
reg x_current;        // Current x value
reg y_timeout_cnt;    // Single bit counter (0-1-2)
reg f_pulse_active;
reg pattern_matched;
reg g_latched;

// Edge detection for reset
reg resetn_prev;
wire resetn_posedge = ~resetn_prev & resetn;

// State transition and control logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        x_history <= 2'b0;
        x_current <= 1'b0;
        y_timeout_cnt <= 1'b0;
        f_pulse_active <= 1'b0;
        pattern_matched <= 1'b0;
        g_latched <= 1'b0;
        resetn_prev <= 1'b0;
    end
    else begin
        resetn_prev <= resetn;
        current_state <= next_state;
        
        // Update x history
        x_current <= x;
        x_history <= {x_history[0], x_current};
        
        // Pattern detection (1-0-1)
        if (x_history == 2'b01 && x_current == 1'b1) begin
            pattern_matched <= 1'b1;
        end
        
        // State-specific processing
        case (current_state)
            STATE_A: begin
                if (resetn_posedge) begin
                    f_pulse_active <= 1'b1;
                end
            end
            
            STATE_F_PULSE: begin
                f_pulse_active <= 1'b0;
            end
            
            STATE_MONITOR: begin
                if (pattern_matched) begin
                    if (y) begin
                        g_latched <= 1'b1;
                    end
                    else if (y_timeout_cnt) begin
                        y_timeout_cnt <= y_timeout_cnt + 1'b1;
                        if (y_timeout_cnt == 1'b1) begin  // After 2 cycles
                            g_latched <= 1'b0;
                        end
                    end
                    else begin
                        y_timeout_cnt <= 1'b1;
                    end
                end
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_A: next_state = resetn_posedge ? STATE_F_PULSE : STATE_A;
        STATE_F_PULSE: next_state = STATE_MONITOR;
        default: next_state = STATE_MONITOR;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end
    else begin
        f <= f_pulse_active;
        g <= pattern_matched ? (g_latched || y) : 1'b0;
    end
end

endmodule