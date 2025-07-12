module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State A (0001) transitions
    wire [3:0] next_A = in ? 4'b0010 : 4'b0001;  // A->B if in=1, else stay A
    
    // State B (0010) transitions
    wire [3:0] next_B = in ? 4'b0010 : 4'b0100;  // B->B if in=1, else B->C
    
    // State C (0100) transitions
    wire [3:0] next_C = in ? 4'b1000 : 4'b0001;  // C->D if in=1, else C->A
    
    // State D (1000) transitions
    wire [3:0] next_D = in ? 4'b0010 : 4'b0100;  // D->B if in=1, else D->C
    
    // Mux-based next state selection
    assign next_state[0] = (state[0] & next_A[0]) | (state[1] & next_B[0]) |
                          (state[2] & next_C[0]) | (state[3] & next_D[0]);
    
    assign next_state[1] = (state[0] & next_A[1]) | (state[1] & next_B[1]) |
                          (state[2] & next_C[1]) | (state[3] & next_D[1]);
    
    assign next_state[2] = (state[0] & next_A[2]) | (state[1] & next_B[2]) |
                          (state[2] & next_C[2]) | (state[3] & next_D[2]);
    
    assign next_state[3] = (state[0] & next_A[3]) | (state[1] & next_B[3]) |
                          (state[2] & next_C[3]) | (state[3] & next_D[3]);
    
    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule