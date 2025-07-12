module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state definitions with parameters
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // Most efficient state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            state <= state ? in : ~in;  // Compact transition logic
            // STATE_B: transition to A when in=0, stay when in=1
            // STATE_A: transition to B when in=0, stay when in=1
        end
    end

    // Minimal combinational output logic
    assign out = (state == STATE_B);  // out=1 in B, out=0 in A

endmodule