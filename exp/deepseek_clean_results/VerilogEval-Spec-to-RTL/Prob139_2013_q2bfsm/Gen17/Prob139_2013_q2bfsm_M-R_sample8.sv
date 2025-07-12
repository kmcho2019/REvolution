module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam [2:0]
    S_IDLE      = 3'd0,
    S_F_PULSE   = 3'd1,
    S_MONITOR_X = 3'd2,
    S_MONITOR_Y = 3'd3,
    S_SUCCESS   = 3'd4,
    S_FAIL      = 3'd5;

reg [2:0] state, next_state;

// Sequence detection for 101 pattern
reg [2:0] x_history;
wire sequence_detected = (x_history == 3'b101);

// Timeout counter for y monitoring (counts 0,1,2)
reg [1:0] y_timeout;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_IDLE;
        x_history <= 3'b0;
        y_timeout <= 2'b0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};
        
        // Update timeout counter
        if (state == S_MONITOR_Y) begin
            y_timeout <= (y_timeout == 2'd2) ? 2'd2 : y_timeout + 1'b1;
        end else begin
            y_timeout <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_IDLE:      next_state = resetn ? S_F_PULSE : S_IDLE;
        S_F_PULSE:   next_state = S_MONITOR_X;
        S_MONITOR_X: next_state = sequence_detected ? S_MONITOR_Y : S_MONITOR_X;
        S_MONITOR_Y: begin
            if (y)          next_state = S_SUCCESS;
            else if (y_timeout == 2'd2) next_state = S_FAIL;
            else            next_state = S_MONITOR_Y;
        end
        S_SUCCESS,
        S_FAIL:      next_state = state;
        default:     next_state = S_IDLE;
    endcase
end

// Output logic
assign f = (state == S_F_PULSE);
assign g = (state == S_SUCCESS) || 
           (state == S_MONITOR_Y && !(state == S_FAIL));

endmodule