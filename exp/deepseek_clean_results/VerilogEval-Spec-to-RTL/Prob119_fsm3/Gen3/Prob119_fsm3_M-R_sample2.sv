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

    // Next state combinational logic using assign
    wire [3:0] next_state;
    assign next_state[0] = (~areset) & ((state[0] & ~in) | (state[2] & ~in));  // A
    assign next_state[1] = (~areset) & ((state[0] & in) | (state[1] & in) | (state[3] & ~in)); // B
    assign next_state[2] = (~areset) & ((state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in)); // C
    assign next_state[3] = (~areset) & (state[2] & in); // D

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic - simply check D state
    assign out = state[3];

endmodule