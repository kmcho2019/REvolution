module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions using Gray code (only one bit changes between states)
    // A = 1'b0, B = 1'b1 (same as before but now part of Gray sequence)
    reg state;
    
    // Dual-edge triggered state machine
    always @(posedge clk or negedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            // Direct state transition equations
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A transitions
                1'b1: state <= in ? 1'b1 : 1'b0;  // B transitions
            endcase
        end
    end
    
    // Output is simply the state bit (B=1, A=0)
    assign out = state;
    
endmodule