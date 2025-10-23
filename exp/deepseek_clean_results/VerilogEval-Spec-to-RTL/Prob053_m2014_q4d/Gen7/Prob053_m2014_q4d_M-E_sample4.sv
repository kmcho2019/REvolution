module TopModule (
    input clk,
    input in,
    output out
);

    reg state;  // Represents the flip-flop state (0 or 1)

    // Next state logic (XOR of current state and input)
    wire next_state = state ^ in;

    // State transition on clock edge
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment
    assign out = state;

endmodule