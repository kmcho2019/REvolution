module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for readability
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Output logic: 1 only if in state D
    assign out = (state == D);

    // Next state logic derived using continuous assignments and conditional expressions:
    // For each bit of next_state, select the value based on current state and input.
    // Next_state bit 1 logic:
    // States with next_state MSB = 0 or 1 depending on the input and current state:
    assign next_state[1] = 
          (state == A && in) ? B[1] :
          (state == B && in) ? B[1] :
          (state == C && in) ? D[1] :
          (state == D && in) ? B[1] :
          (state == A && !in) ? A[1] :
          (state == B && !in) ? C[1] :
          (state == C && !in) ? A[1] :
          (state == D && !in) ? C[1] : 1'b0;

    // Next_state bit 0 logic:
    assign next_state[0] =
          (state == A && in) ? B[0] :
          (state == B && in) ? B[0] :
          (state == C && in) ? D[0] :
          (state == D && in) ? B[0] :
          (state == A && !in) ? A[0] :
          (state == B && !in) ? C[0] :
          (state == C && !in) ? A[0] :
          (state == D && !in) ? C[0] : 1'b0;

endmodule