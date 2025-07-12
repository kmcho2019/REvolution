module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // T flip-flop implementation
    reg state;
    wire t_input = state ^ ~in;  // Toggles when (state != ~in)
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B (out=1)
        end else begin
            state <= state ^ t_input;  // T flip-flop behavior
        end
    end

    assign out = ~state;  // Output is complement of state

endmodule