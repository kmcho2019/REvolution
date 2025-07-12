module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits [3:0] represent states D, C, B, A respectively

    // Parallel state transition logic
    wire next_A = (~areset) & ((state[0] & ~in) | (state[2] & ~in));
    wire next_B = (~areset) & ((state[0] & in) | (state[1] & in) | (state[3] & in));
    wire next_C = (~areset) & ((state[1] & ~in) | (state[3] & ~in));
    wire next_D = (~areset) & (state[2] & in);

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            state <= {next_D, next_C, next_B, next_A};
        end
    end

    // Output is simply the D state bit
    assign out = state[3];

endmodule