module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using continuous assignments
    wire next_A = (state[A] & ~in) | (state[C] & ~in);
    wire next_B = (state[A] & in)  | (state[B] & in)  | (state[D] & in);
    wire next_C = (state[B] & ~in) | (state[D] & ~in);
    wire next_D = (state[C] & in);

    // Combine one-hot next state signals
    always @(*) begin
        next_state = 4'b0000;
        if (next_A) next_state[A] = 1'b1;
        else if (next_B) next_state[B] = 1'b1;
        else if (next_C) next_state[C] = 1'b1;
        else if (next_D) next_state[D] = 1'b1;
        else next_state = A; // default fallback
    end

    // Output is high only in state D (Moore output)
    assign out = state[D];

endmodule