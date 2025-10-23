module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
parameter [1:0] 
    IDLE      = 2'b00,
    F_PULSE   = 2'b01,
    MONITOR_Y = 2'b10,
    FINAL     = 2'b11;

reg [1:0] state, next_state;

// Pattern detection shift register
reg [2:0] x_pattern;
wire pattern_match = (x_pattern == 3'b101);

// Timeout counter (2 cycles)
reg [1:0] y_timeout;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_pattern <= 3'b0;
        y_timeout <= 2'b0;
    end else begin
        state <= next_state;
        x_pattern <= {x_pattern[1:0], x};
        
        // Update timeout counter
        if (state == MONITOR_Y && !y) begin
            y_timeout <= y_timeout + 1;
        end else begin
            y_timeout <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE:      next_state = resetn ? F_PULSE : IDLE;
        F_PULSE:   next_state = pattern_match ? MONITOR_Y : F_PULSE;
        MONITOR_Y: begin
            if (y) 
                next_state = FINAL;
            else if (y_timeout == 2'b10) // After 2 cycles
                next_state = FINAL;
            else
                next_state = MONITOR_Y;
        end
        FINAL:     next_state = FINAL;
        default:   next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f is high for one cycle after reset
        f <= (state == IDLE && next_state == F_PULSE);
        
        // g control
        case (next_state)
            MONITOR_Y: g <= 1'b1;
            FINAL:    g <= (y_timeout != 2'b10); // 1 if y was detected, 0 if timeout
            default:   g <= 1'b0;
        endcase
    end
end

endmodule