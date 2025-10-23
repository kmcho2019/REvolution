module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] state;

    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state[0] = (~state[0] | ~in) & (~state[1] | in) & (~state[2] | ~in) & (~state[3] | ~in);
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    assign next_state[2] = (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in);
    assign next_state[3] = state[2] & in;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output is directly state D (one-hot bit 3)
    assign out = state[3];

endmodule