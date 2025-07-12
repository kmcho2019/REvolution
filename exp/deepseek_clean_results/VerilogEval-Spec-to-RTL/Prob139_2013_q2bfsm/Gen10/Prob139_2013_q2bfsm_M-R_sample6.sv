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
localparam STATE_E = 3'd4;  // g permanently 1
localparam STATE_F = 3'd5;  // g permanently 0

reg [2:0] state;
reg x_prev1, x_prev2;  // Previous two x values
reg [1:0] timeout;     // 2-bit counter for timeout

// Output logic
assign f = (state == STATE_B);
assign g = (state == STATE_E) || (state == STATE_D && y);

// State transitions and sequence tracking
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
            STATE_A: state <= STATE_B;
            
            STATE_B: state <= STATE_C;
            
            STATE_C: begin
                if (x && !x_prev1 && x_prev2)
                    state <= STATE_D;
            end
            
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;  // y=1 detected, g permanent 1
                end else if (timeout == 2'd1) begin
                    state <= STATE_F; // timeout reached, g permanent 0
                end else begin
                    timeout <= timeout + 1; // increment timeout counter
                end
            end
            
            // Permanent states (until reset)
            STATE_E: state <= STATE_E;
            STATE_F: state <= STATE_F;
        endcase
    end
end

endmodule