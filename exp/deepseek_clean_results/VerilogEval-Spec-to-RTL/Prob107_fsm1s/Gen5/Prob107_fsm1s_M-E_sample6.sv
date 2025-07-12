module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code encoding: B=0, A=1
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // Reset to state B
        else
            // State transition: next_state = state ^ (~state & in)
            state <= state ^ (~state & in);
    end

    // Output is simply ~state (Moore output)
    assign out = ~state;

endmodule