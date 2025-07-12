module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] current_state;

    // Next state logic using continuous assignments
    wire [5:0] next_state;
    assign next_state[A] = (current_state[A] & ~w) | 
                          (current_state[D] & ~w);
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

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (z is 1 in states E and F)
    assign z = current_state[E] | current_state[F];

endmodule