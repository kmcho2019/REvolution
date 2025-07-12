module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse (one cycle)
localparam STATE_C = 3'd2;  // Monitor x for 1-0-1
localparam STATE_D = 3'd3;  // Monitor y with timeout
localparam STATE_E = 3'd4;  // Permanent g=1
localparam STATE_F = 3'd5;  // Permanent g=0

reg [2:0] state;
reg [2:0] x_history;  // Shift register for x sequence
reg timeout;          // Tracks timeout for y monitoring

// Output assignments
assign f = (state == STATE_B);
assign g = (state == STATE_E);

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 3'b000;
        timeout <= 0;
    end
    else begin
        // Update x history shift register
        x_history <= {x_history[1:0], x};
        
        case (state)
            STATE_A: state <= STATE_B;  // Move to pulse state
            
            STATE_B: state <= STATE_C;  // Single cycle pulse
            
            STATE_C: begin
                if (x_history == 3'b101) begin
                    state <= STATE_D;
                    timeout <= 0;
                end
            end
            
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;  // y=1 detected
                end
                else if (timeout) begin
                    state <= STATE_F;  // Timeout reached
                end
                else begin
                    timeout <= 1;      // Mark timeout after first cycle
                end
            end
            
            // STATE_E and STATE_F are permanent until reset
            default: state <= state;
        endcase
    end
end

endmodule