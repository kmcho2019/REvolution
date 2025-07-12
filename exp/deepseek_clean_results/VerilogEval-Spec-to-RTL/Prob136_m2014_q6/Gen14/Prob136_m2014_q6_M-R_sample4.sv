module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    reg [5:0] state;
    wire [5:0] next_state;

    // State definitions
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // Next state combinational logic
    assign next_state[A] = (state[A] & w) | (state[D] & w);
    assign next_state[B] = (state[A] & ~w);
    assign next_state[C] = (state[B] & ~w) | (state[F] & ~w);
    assign next_state[D] = (state[B] & w) | (state[C] & w) | (state[E] & w) | (state[F] & w);
    assign next_state[E] = (state[C] & ~w) | (state[E] & ~w);
    assign next_state[F] = (state[D] & ~w);

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign z = state[E] | state[F];

endmodule