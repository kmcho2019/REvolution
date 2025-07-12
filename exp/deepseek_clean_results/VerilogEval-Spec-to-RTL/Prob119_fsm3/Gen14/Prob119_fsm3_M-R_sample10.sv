module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states A, B, C, D respectively

    // Next state combinational logic
    wire [3:0] next_state;
    assign next_state[0] = (~state[0] | ~in) & (~state[1] | in) & (state[2] & ~in) & (~state[3]);
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    assign next_state[2] = (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in);
    assign next_state[3] = state[2] & in;

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= 4'b0001;  // Reset to state A
        else state <= next_state;
    end

    // Output logic (state D is active)
    assign out = state[3];

endmodule