module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states A, B, C, D respectively

    // State transition logic
    wire next_A = (state[0] & ~in) | (state[2] & ~in);
    wire next_B = (state[0] & in) | (state[1] & in) | (state[3] & in);
    wire next_C = (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in);
    wire next_D = (state[2] & in);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A (one-hot)
        end else begin
            state <= {next_D, next_C, next_B, next_A};
        end
    end

    // Output logic (1 when in state D)
    assign out = state[3];

endmodule