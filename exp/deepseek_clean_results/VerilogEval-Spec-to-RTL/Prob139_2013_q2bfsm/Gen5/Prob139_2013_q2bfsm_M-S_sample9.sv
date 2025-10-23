module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse and monitor x
localparam STATE_C = 2'd2;  // Monitor y with timeout
localparam STATE_D = 2'd3;  // Final permanent state

reg [1:0] state;
reg [2:0] x_history;  // Shift register for x sequence detection
reg y_timeout;        // Tracks if we're in second cycle of y monitoring

// Outputs are combinatorial
assign f = (state == STATE_B);
assign g = (state == STATE_C || state == STATE_D) && !y_timeout;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 3'b000;
        y_timeout <= 0;
    end
    else begin
        // Update x history shift register
        x_history <= {x_history[1:0], x};
        
        case (state)
            STATE_A: begin
                state <= STATE_B;  // Move to pulse state after reset
            end
            
            STATE_B: begin
                // Check for 101 sequence in x_history
                if (x_history == 3'b101) begin
                    state <= STATE_C;
                    y_timeout <= 0;
                end
            end
            
            STATE_C: begin
                if (y) begin
                    state <= STATE_D;  // y=1 detected
                end
                else if (y_timeout) begin
                    state <= STATE_D;  // Timeout reached
                end
                else begin
                    y_timeout <= 1;    // Mark first timeout cycle
                end
            end
            
            STATE_D: begin
                // Permanent state - no transitions
            end
        endcase
    end
end

endmodule