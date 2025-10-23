module TopModule (
    input clk,
    input in,
    output out
);

    // Define states (only 1 bit needed)
    reg state;

    // Next state logic (XOR of input and current state)
    wire next_state = in ^ state;

    // Output is just the current state
    assign out = state;

    // State transition on clock edge
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule