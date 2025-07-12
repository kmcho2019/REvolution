module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] current_state;
    wire [5:0] next_state;

    // Parallel state transition decoder
    assign next_state[A] = (current_state[A] & ~w) | 
                          (current_state[D] & ~w) |
                          (current_state[E] & ~w) |
                          (current_state[F] & ~w);

    assign next_state[B] = (current_state[A] & w);
    assign next_state[C] = (current_state[B] & w) | 
                          (current_state[F] & w);
    assign next_state[D] = (current_state[B] & ~w) |
                          (current_state[C] & ~w) |
                          (current_state[E] & ~w) |
                          (current_state[F] & ~w);
    assign next_state[E] = (current_state[C] & w) |
                          (current_state[E] & w);
    assign next_state[F] = (current_state[D] & w);

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output prediction - look at next state to break critical path
    always @(*) begin
        z = next_state[E] | next_state[F];
    end

endmodule