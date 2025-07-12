module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named state constants for better readability
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;  // Current state register

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            // Compact state transition:
            // B -> A when in=0, stay B when in=1
            // A -> B when in=0, stay A when in=1
            state <= state ? in : ~in;
        end
    end

    // Output logic - Moore style (output depends only on state)
    assign out = (state == STATE_B);  // 1 when in B, 0 when in A

endmodule