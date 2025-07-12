module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;

    // Next state logic (combinational)
    wire next_state_A = ~x & state[0];  // Stay in A only if x=0
    wire next_state_B = (state[0] & x) | state[1];  // Move to B on x=1 or stay

    // Output logic (combinational Mealy output)
    assign z = state[0] ? x : ~x;

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A (one-hot)
            state <= 2'b01;
        end else begin
            // Normal state transition
            state <= {next_state_B, next_state_A};
        end
    end

endmodule