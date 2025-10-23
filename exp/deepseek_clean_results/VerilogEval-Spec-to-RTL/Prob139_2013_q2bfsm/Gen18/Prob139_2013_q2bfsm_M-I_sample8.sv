module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [2:0] {
    IDLE,
    F_PULSE,
    WAIT_X,
    DETECT_X,
    FINAL
} state_t;

reg [2:0] state, next_state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] timeout;    // 2-bit timeout counter
reg g_perm;           // Permanent g value

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 3'b0;
        timeout <= 2'b0;
        g_perm <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};
        
        // Timeout counter logic
        if (state == DETECT_X) begin
            if (y) begin
                timeout <= 2'b0;
                g_perm <= 1;
            end else if (timeout != 2'b11) begin
                timeout <= timeout + 1;
            end else begin
                g_perm <= 0;
            end
        end else begin
            timeout <= 2'b0;
        end
        
        // Output generation
        f <= (next_state == F_PULSE);
        g <= (next_state == DETECT_X && x_history[2:0] == 3'b101) || 
             (next_state == FINAL && g_perm);
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE:      if (resetn) next_state = F_PULSE;
        F_PULSE:   next_state = WAIT_X;
        WAIT_X:    if (x_history[1:0] == 2'b10) next_state = DETECT_X;
        DETECT_X: begin
            if (x_history[2:0] == 3'b101) begin
                if (y || timeout == 2'b10) begin
                    next_state = FINAL;
                end
            end else begin
                next_state = WAIT_X;
            end
        end
        FINAL:     next_state = FINAL;  // Stay until reset
    endcase
end

endmodule