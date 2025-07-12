module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    reg [5:0] state;
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    wire [5:0] next_state;

    // Parallel next state computation
    assign next_state[A] = (state[A] & w) | (state[D] & w);
    assign next_state[B] = state[A] & ~w;
    assign next_state[C] = (state[B] & ~w) | (state[F] & ~w);
    assign next_state[D] = (state[B] & w) | (state[C] & w) | 
                          (state[E] & w) | (state[F] & w);
    assign next_state[E] = (state[C] & ~w) | (state[E] & ~w);
    assign next_state[F] = state[D] & ~w;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is high for states E or F (bits 4 or 5)
    assign z = state[4] | state[5];

endmodule