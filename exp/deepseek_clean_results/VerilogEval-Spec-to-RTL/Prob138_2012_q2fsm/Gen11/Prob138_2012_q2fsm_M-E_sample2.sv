module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state;
    wire [5:0] next_state;

    // Parallel next state logic using one-hot advantages
    assign next_state[A] = (~reset) & ((current_state[A] & ~w) | 
                          (current_state[D] & ~w));
    
    assign next_state[B] = (~reset) & ((current_state[A] & w) | 
                          (current_state[F] & ~w));
    
    assign next_state[C] = (~reset) & ((current_state[B] & w) | 
                          (current_state[F] & w));
    
    assign next_state[D] = (~reset) & ((current_state[B] & ~w) | 
                          (current_state[C] & ~w) | 
                          (current_state[E] & ~w) | 
                          (current_state[F] & ~w));
    
    assign next_state[E] = (~reset) & ((current_state[C] & w) | 
                          (current_state[E] & w));
    
    assign next_state[F] = (~reset) & (current_state[D] & w);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output is directly wired from E or F states
    assign z = current_state[E] | current_state[F];

endmodule