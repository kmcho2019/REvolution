module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
typedef enum {
    RESET,
    F_PULSE,
    PATTERN_DETECT,
    Y_MONITOR,
    G_PERM_1,
    G_PERM_0
} state_t;

reg [2:0] state, next_state;
reg [2:0] x_shift;
reg [1:0] timeout;
reg f_reg;

// Continuous output assignments
assign f = f_reg;
assign g = (state == G_PERM_1) || (state == Y_MONITOR && timeout < 2);

// Shift register for pattern detection
always @(posedge clk) begin
    if (!resetn) begin
        x_shift <= 3'b0;
    end else begin
        x_shift <= {x_shift[1:0], x};
    end
end

// Timeout counter
always @(posedge clk) begin
    if (!resetn || state != Y_MONITOR) begin
        timeout <= 2'b0;
    end else if (!y) begin
        timeout <= timeout + 1;
    end
end

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f_reg <= 1'b0;
    end else begin
        state <= next_state;
        f_reg <= (next_state == F_PULSE);
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        RESET: 
            if (resetn) next_state = F_PULSE;
            
        F_PULSE:
            next_state = PATTERN_DETECT;
            
        PATTERN_DETECT:
            if (x_shift == 3'b101) next_state = Y_MONITOR;
            
        Y_MONITOR:
            if (y) 
                next_state = G_PERM_1;
            else if (timeout == 2'b10)
                next_state = G_PERM_0;
                
        G_PERM_1, G_PERM_0:
            next_state = state; // Stay permanently until reset
    endcase
end

endmodule