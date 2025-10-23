module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// One-hot state encoding
parameter [5:0] 
    IDLE      = 6'b000001,
    F_PULSE   = 6'b000010,
    WAIT_PAT  = 6'b000100,
    MONITOR_Y = 6'b001000,
    G_HIGH    = 6'b010000,
    G_LOW     = 6'b100000;

reg [5:0] current_state, next_state;

// Pattern detection registers
reg x1, x0;  // Stores last two x values
wire pattern_match = x1 & ~x0 & x;  // Detects 1-0-1 sequence

// Timer for y monitoring
reg [1:0] y_timer;
wire y_timeout = (y_timer == 2'b10);

// Output assignments
assign f = (current_state == F_PULSE);
assign g = (current_state == G_HIGH) || 
           ((current_state == MONITOR_Y) && !y_timeout);

// State transition and registers
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x1 <= 0;
        x0 <= 0;
        y_timer <= 0;
    end else begin
        current_state <= next_state;
        
        // Shift register for x pattern
        x1 <= x0;
        x0 <= x;
        
        // Timer logic
        if (current_state == MONITOR_Y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:      next_state = resetn ? F_PULSE : IDLE;
        F_PULSE:   next_state = WAIT_PAT;
        WAIT_PAT:  next_state = pattern_match ? MONITOR_Y : WAIT_PAT;
        MONITOR_Y: begin
            if (y)          next_state = G_HIGH;
            else if (y_timeout) next_state = G_LOW;
            else            next_state = MONITOR_Y;
        end
        G_HIGH:    next_state = G_HIGH;
        G_LOW:     next_state = G_LOW;
        default:   next_state = IDLE;
    endcase
end

endmodule