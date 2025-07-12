module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for clarity
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // One-hot decode current state
    wire is_A = (state == A);
    wire is_B = (state == B);
    wire is_C = (state == C);
    wire is_D = (state == D);

    // Next state bit 1 (MSB) logic:
    // From transitions:
    // A->A(00)/B(01): next_state[1]=0 in both cases
    // B->C(10)/B(01): next_state[1]=1 when in=0, 0 when in=1
    // C->A(00)/D(11): next_state[1]=0 when in=0, 1 when in=1
    // D->C(10)/B(01): next_state[1]=1 when in=0, 0 when in=1
    // Simplify with boolean:
    // next_state[1] = (is_B & ~in) | (is_C & in) | (is_D & ~in);

    // Next state bit 0 (LSB) logic:
    // A->A(00)/B(01): next_state[0]=0 when in=0, 1 when in=1
    // B->C(10)/B(01): next_state[0]=0 when in=0, 1 when in=1
    // C->A(00)/D(11): next_state[0]=0 when in=0, 1 when in=1
    // D->C(10)/B(01): next_state[0]=0 when in=0, 1 when in=1
    // next_state[0] = in; always 0 when in=0, 1 when in=1 for all states except D and C when next_state is D or C 
    // Check D:
    // D->C(10)/B(01): next_state[0]=0 (C) when in=0, 1 (B) when in=1, so aligns with 'in'
    // So next_state[0] = in for all states

    // Output logic (Moore output):
    // out=1 only in state D, else 0
    // out = is_D

    assign next_state[1] = (is_B & ~in) | (is_C & in) | (is_D & ~in);
    assign next_state[0] = in;
    assign out = is_D;

endmodule