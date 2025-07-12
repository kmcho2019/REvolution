module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // Monitoring x for 1-0-1 sequence
localparam STATE_C = 2'd2;  // Monitoring y with timeout
localparam STATE_D = 2'd3;  // Final permanent state

reg [1:0] state, next_state;
reg [1:0] timeout_counter;
reg [2:0] x_history;  // Shift register for x pattern detection

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        timeout_counter <= 0;
        x_history <= 3'b000;
    end
    else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};  // Shift in new x value
        
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                f <= 1;  // Pulse f=1 for one cycle
                next_state <= STATE_B;
            end
            
            STATE_B: begin
                // Check for 1-0-1 pattern in last 3 cycles
                if (x_history == 3'b101) begin
                    g <= 1;
                    next_state <= STATE_C;
                    timeout_counter <= 0;
                end
            end
            
            STATE_C: begin
                if (y) begin
                    next_state <= STATE_D;  // y=1 detected, stay permanently
                end
                else if (timeout_counter == 2'd1) begin
                    g <= 0;               // Timeout reached
                    next_state <= STATE_D;
                end
                else begin
                    timeout_counter <= timeout_counter + 1;
                end
            end
            
            STATE_D: begin
                // Permanent state - maintain g value
            end
        endcase
    end
end

endmodule