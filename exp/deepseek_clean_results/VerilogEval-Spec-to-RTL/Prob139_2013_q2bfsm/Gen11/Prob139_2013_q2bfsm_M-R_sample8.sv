module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam S_RESET   = 2'b00;
localparam S_F_PULSE = 2'b01;
localparam S_MONITOR = 2'b10;
localparam S_FINAL   = 2'b11;

reg [1:0] state, next_state;
reg [2:0] x_pattern;  // Stores last 3 x values
reg y_timeout;        // Flag for y monitoring timeout
reg f_pulse;          // One-cycle f pulse

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_RESET;
        x_pattern <= 0;
        y_timeout <= 0;
    end else begin
        state <= next_state;
        
        // Shift in new x value
        x_pattern <= {x_pattern[1:0], x};
        
        // Update y timeout counter
        if (state == S_MONITOR && !y_timeout)
            y_timeout <= (x_pattern == 3'b101) ? 1 : 0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_RESET:   next_state = resetn ? S_F_PULSE : S_RESET;
        S_F_PULSE: next_state = S_MONITOR;
        S_MONITOR: begin
            if (x_pattern == 3'b101 && y)
                next_state = S_FINAL;
            else if (x_pattern == 3'b101 && y_timeout)
                next_state = S_FINAL;
            else
                next_state = S_MONITOR;
        end
        S_FINAL:   next_state = S_FINAL;
        default:   next_state = S_RESET;
    endcase
end

// Output logic
assign f = (state == S_F_PULSE);
assign g = (state == S_FINAL) ? (x_pattern == 3'b101 && !y_timeout) : 0;

endmodule