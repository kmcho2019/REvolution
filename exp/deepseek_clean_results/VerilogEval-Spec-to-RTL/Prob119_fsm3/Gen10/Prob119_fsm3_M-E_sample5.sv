module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state; // bits represent states A,B,C,D respectively

    // State definitions for readability
    localparam A_bit = 0;
    localparam B_bit = 1;
    localparam C_bit = 2;
    localparam D_bit = 3;

    // Sequential state transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001; // Reset to state A (bit 0 set)
        end else begin
            // Compute next state directly
            state[A_bit] <= (state[A_bit] & ~in) | (state[C_bit] & ~in);
            state[B_bit] <= (state[A_bit] & in) | (state[B_bit] & in) | (state[D_bit] & in);
            state[C_bit] <= (state[B_bit] & ~in) | (state[D_bit] & ~in);
            state[D_bit] <= (state[C_bit] & in);
        end
    end

    // Output is simply the D state bit
    assign out = state[D_bit];

endmodule