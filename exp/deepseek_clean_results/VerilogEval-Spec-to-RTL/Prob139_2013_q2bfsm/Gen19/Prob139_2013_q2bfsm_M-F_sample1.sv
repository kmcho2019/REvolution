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
    F_PULSE   = 3'b001,
    WAIT_PAT  = 3'b010,
    MONITOR_Y = 3'b011,
    G_HIGH    = 3'b100,
    G_LOW     = 3'b101;

reg [2:0] current_state, next_state;
reg [2:0] x_shift_reg;
reg [1:0] y_timer;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift_reg <= 3'b0;
        y_timer <= 2'b0;
    end else begin
        current_state <= next_state;
        x_shift_reg <= {x_shift_reg[1:0], x};
        
        // Update y timer when in MONITOR_Y state
        if (current_state == MONITOR_Y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 2'b0;
        end
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE:      next_state = resetn ? F_PULSE : IDLE;
        F_PULSE:   next_state = WAIT_PAT;
        WAIT_PAT:  next_state = (x_shift_reg == 3'b101) ? MONITOR_Y : WAIT_PAT;
        MONITOR_Y: begin
            if (y) next_state = G_HIGH;
            else if (y_timer == 2'b10) next_state = G_LOW;
            else next_state = MONITOR_Y;
        end
        G_HIGH:    next_state = G_HIGH;
        G_LOW:     next_state = G_LOW;
        default:   next_state = IDLE;
    endcase
end

// Output logic (combinational)
always @(*) begin
    f = (current_state == F_PULSE);
    case (current_state)
        G_HIGH:    g = 1'b1;
        G_LOW:     g = 1'b0;
        MONITOR_Y: g = 1'b1;
        default:   g = 1'b0;
    endcase
end

endmodule