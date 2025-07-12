module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state; // bits represent states A, B, C, D respectively

    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state[0] = (~areset) & ((state[0] & ~in) | (state[2] & ~in)); // A or C->A
    assign next_state[1] = (~areset) & ((state[0] & in) | (state[1] & in) | (state[3] & in)); // A->B or B->B or D->B
    assign next_state[2] = (~areset) & ((state[1] & ~in) | (state[3] & ~in)); // B->C or D->C
    assign next_state[3] = (~areset) & (state[2] & in); // C->D

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001; // Reset to state A
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state[3]; // Output 1 when in state D

endmodule