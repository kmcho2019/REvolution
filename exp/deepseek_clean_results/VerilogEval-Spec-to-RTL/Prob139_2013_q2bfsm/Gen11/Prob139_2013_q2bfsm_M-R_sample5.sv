module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State definitions
typedef enum {
    ST_RESET,
    ST_IDLE,
    ST_PULSE_F,
    ST_MONITOR_X,
    ST_CHECK_Y,
    ST_FINAL
} state_t;

reg [2:0] state;
reg [2:0] x_history;  // Shift register for x sequence
reg [1:0] timeout_cnt; // 2-bit timeout counter

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= ST_RESET;
        x_history <= 3'b0;
        timeout_cnt <= 2'b0;
    end
    else begin
        case (state)
            ST_RESET: state <= ST_IDLE;
            
            ST_IDLE: state <= ST_PULSE_F;
            
            ST_PULSE_F: begin
                state <= ST_MONITOR_X;
                x_history <= 3'b0;
            end
            
            ST_MONITOR_X: begin
                // Shift in new x value
                x_history <= {x_history[1:0], x};
                
                // Check for 1-0-1 sequence
                if (x_history == 3'b101) begin
                    state <= ST_CHECK_Y;
                    timeout_cnt <= 2'b0;
                end
            end
            
            ST_CHECK_Y: begin
                if (y) begin
                    state <= ST_FINAL;
                end
                else if (timeout_cnt == 2'b01) begin
                    state <= ST_FINAL;
                end
                else begin
                    timeout_cnt <= timeout_cnt + 1;
                end
            end
            
            ST_FINAL: begin
                // Stay in final state until reset
                state <= ST_FINAL;
            end
        endcase
    end
end

// Output logic (combinational)
assign f = (state == ST_PULSE_F);
assign g = (state == ST_CHECK_Y) || 
           ((state == ST_FINAL) && (timeout_cnt != 2'b01));

endmodule