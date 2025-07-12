module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'd0;
localparam STATE_B = 3'd1;
localparam STATE_C = 3'd2;
localparam STATE_D = 3'd3;
localparam STATE_E = 3'd4;

reg [2:0] state;
reg x_prev1, x_prev2;  // Previous two x values
reg timeout;           // Timeout counter for STATE_D

// Combinational outputs
assign f = (state == STATE_B);
assign g = (state == STATE_E) || (state == STATE_D && y);

// Single always block for state transitions and sequence tracking
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_prev1 <= 0;
        x_prev2 <= 0;
        timeout <= 0;
    end else begin
        // Update x history
        x_prev2 <= x_prev1;
        x_prev1 <= x;

        case (state)
            STATE_A: state <= STATE_B;  // Always transition to B after reset
            
            STATE_B: state <= STATE_C;  // Single-cycle state for f=1
            
            STATE_C: begin
                // Check for 1-0-1 sequence (current x is 1, prev1 is 0, prev2 is 1)
                if (x && !x_prev1 && x_prev2)
                    state <= STATE_D;
            end
            
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;  // y=1 detected
                end else if (timeout) begin
                    state <= STATE_E;  // Timeout after 2 cycles
                end else begin
                    timeout <= ~timeout;  // Toggle timeout counter
                end
            end
            
            // STATE_E remains permanently
            STATE_E: state <= STATE_E;
        endcase
    end
end

endmodule