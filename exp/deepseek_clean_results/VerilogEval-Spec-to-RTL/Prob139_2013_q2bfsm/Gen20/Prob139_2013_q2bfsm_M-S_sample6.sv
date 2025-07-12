module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Simplified state encoding
parameter [2:0] 
    IDLE    = 3'b000,
    F_PULSE = 3'b001,
    WAIT_X  = 3'b010,
    CHECK_Y = 3'b011,
    FINAL   = 3'b100;

reg [2:0] state, next_state;
reg [1:0] x_pattern;
reg y_timer;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_pattern <= 2'b0;
        y_timer <= 0;
    end else begin
        state <= next_state;
        x_pattern <= {x_pattern[0], x};  // 2-bit shift register for pattern
        y_timer <= (state == CHECK_Y) ? y_timer + 1 : 0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE:    next_state = resetn ? F_PULSE : IDLE;
        F_PULSE: next_state = WAIT_X;
        WAIT_X:  next_state = (x_pattern == 2'b01 && x == 1'b1) ? CHECK_Y : WAIT_X;
        CHECK_Y: begin
            if (y) next_state = FINAL;
            else if (y_timer) next_state = FINAL;
            else next_state = CHECK_Y;
        end
        FINAL:   next_state = FINAL;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    f = (state == F_PULSE);
    g = (state == FINAL) ? y : 0;
end

endmodule