module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// States
typedef enum logic [1:0] {
    IDLE,
    DETECT,
    FINAL
} state_t;

reg [1:0] state, next_state;
reg [2:0] x_history;  // Stores last 3 x values
reg timeout;          // 1-bit timeout for 2-cycle window
reg f_pulse;          // f pulse register

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 3'b0;
        timeout <= 0;
        f_pulse <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};
        
        // Timeout tracking (1 bit = 2 cycles)
        if (state == DETECT && x_history == 3'b101) begin
            timeout <= ~timeout; // Toggle each cycle
        end else begin
            timeout <= 0;
        end
        
        // f pulse generation
        f_pulse <= (state == IDLE && resetn);
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE:   if (resetn) next_state = DETECT;
        DETECT: if (x_history == 3'b101 && (y || timeout)) 
                    next_state = FINAL;
        FINAL:  next_state = FINAL; // Stay until reset
    endcase
end

// Output logic
assign f = f_pulse;
assign g = (state == FINAL) ? (y || !timeout) : 
           (state == DETECT && x_history == 3'b101);

endmodule