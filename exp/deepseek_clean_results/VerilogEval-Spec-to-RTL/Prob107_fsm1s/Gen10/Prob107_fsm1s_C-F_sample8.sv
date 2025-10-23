module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named states for better readability
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            // Compact yet readable state transition
            state <= (state == STATE_B) ? ~in : in;
        end
    end

    // Output logic (combinational)
    assign out = (state == STATE_B);  // Output 1 in state B, 0 in state A

endmodule