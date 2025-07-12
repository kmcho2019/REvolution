module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
parameter [2:0] 
    IDLE      = 3'b000,
    F_STATE   = 3'b001,
    MONITOR_X = 3'b010,
    MONITOR_Y = 3'b011,
    G_HIGH    = 3'b100,
    G_LOW     = 3'b101;

reg [2:0] state, next_state;
reg [2:0] x_shift;
reg [1:0] y_timeout;
reg f_pulse;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_shift <= 3'b0;
        y_timeout <= 2'b0;
        f_pulse <= 1'b0;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        // Generate one-cycle f pulse
        if (state == IDLE)
            f_pulse <= 1'b1;
        else
            f_pulse <= 1'b0;
            
        // Count y monitoring timeout
        if (state == MONITOR_Y) begin
            if (y_timeout < 2)
                y_timeout <= y_timeout + 1;
        end else begin
            y_timeout <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE:      next_state = resetn ? F_STATE : IDLE;
        F_STATE:   next_state = MONITOR_X;
        MONITOR_X: next_state = (x_shift == 3'b101) ? MONITOR_Y : MONITOR_X;
        MONITOR_Y: begin
            if (y)
                next_state = G_HIGH;
            else if (y_timeout == 2)
                next_state = G_LOW;
            else
                next_state = MONITOR_Y;
        end
        G_HIGH:    next_state = G_HIGH;
        G_LOW:     next_state = G_LOW;
        default:   next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    f = f_pulse;
    g = (state == G_HIGH) || (state == MONITOR_Y && y_timeout < 2);
end

endmodule