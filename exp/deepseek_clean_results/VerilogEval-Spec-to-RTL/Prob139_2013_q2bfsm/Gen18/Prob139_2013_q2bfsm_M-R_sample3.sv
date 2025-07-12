module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
parameter [1:0] 
    IDLE      = 2'b00,
    F_PULSE   = 2'b01,
    MONITOR_Y = 2'b10,
    FINAL     = 2'b11;

reg [1:0] current_state, next_state;
reg [2:0] x_shift_reg;
reg y_timeout_flag;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift_reg <= 3'b0;
        y_timeout_flag <= 1'b0;
    end else begin
        current_state <= next_state;
        x_shift_reg <= {x_shift_reg[1:0], x};
        
        // Set timeout flag if y not detected within 2 cycles
        if (current_state == MONITOR_Y && !y) begin
            y_timeout_flag <= (y_timeout_flag || (x_shift_reg[0] == 1'b1)); // Using x_shift_reg[0] as cycle counter
        end else begin
            y_timeout_flag <= 1'b0;
        end
    end
end

// Next state logic (combinational)
assign next_state = 
    (!resetn) ? IDLE :
    (current_state == IDLE) ? F_PULSE :
    (current_state == F_PULSE && x_shift_reg == 3'b101) ? MONITOR_Y :
    (current_state == MONITOR_Y && y) ? FINAL :
    (current_state == MONITOR_Y && y_timeout_flag) ? FINAL :
    current_state;

// Output logic (combinational)
assign f = (current_state == IDLE && resetn);
assign g = (current_state == MONITOR_Y) || 
           (current_state == FINAL && !y_timeout_flag);

endmodule