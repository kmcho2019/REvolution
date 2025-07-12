module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters (output matches state value)
    parameter STATE_B = 1'b1;  // out=1 when in state B
    parameter STATE_A = 1'b0;  // out=0 when in state A

    reg state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Reset to state B
        end else begin
            state <= (state == STATE_B) ? (in ? STATE_B : STATE_A) 
                                       : (in ? STATE_A : STATE_B);
        end
    end

    // Direct output assignment (state value is output)
    assign out = state;

endmodule