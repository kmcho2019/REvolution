module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Current state wire (feedback)
    wire state;
    // Next state logic
    wire next_state = reset ? 1'b0 : 
                    (state ? (k ? 1'b0 : 1'b1) : 
                            (j ? 1'b1 : 1'b0));

    // State register implemented with feedback
    assign state = next_state;

    // Output logic
    assign out = state;

endmodule