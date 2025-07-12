module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;
    wire next_state;

    // Optimized next state logic
    assign next_state = (state ^ ~in); // XOR-based state transition

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B
        else
            state <= next_state;
    end

    // Output is the state value
    assign out = state;

endmodule