module TopModule(
    input       in,
    input [1:0] state,
    output [1:0] next_state,
    output      out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Decompose state bits for readability
    wire s1 = state[1];
    wire s0 = state[0];

    // next_state[1] logic:
    // From the table:
    // next_state[1] = 0 for states A(00), B(01), C(10) except D(11) outputs 1 for in=1
    // Re-express via transitions:
    // For in=0: next_state = A(00), C(10), A(00), C(10) for A,B,C,D respectively
    // For in=1: next_state = B(01), B(01), D(11), B(01)
    // Analyzing next_state[1]:
    // in=0: next_state[1] = state[1] & ~state[0] (C or A)
    // in=1: next_state[1] = 0 except D(11) -> D=11, next_state= B(01) except C->D(11)
    // From table: next_state[1] = (state==C & in) ? 1 : 0
    wire next_state_1 = (s1 & ~s0 & in); // only C and in=1 produces next_state=11 (bit1=1)

    // next_state[0] logic:
    // In the table:
    // in=0: A->A(00), B->C(10), C->A(00), D->C(10)
    // next_state[0] = 0 for A and C; 0 for D; 0 for B except B->C which is 10, bit0=0
    // in=1: A->B(01), B->B(01), C->D(11), D->B(01)
    // next_state[0]=1 for B(01) and D(11) => next_state[0]=1 except C->D which has bit0=1
    // Actually, next_state[0] = ( (state == A or B or D) & in ) or (state==C & in=0) -> complicated
    // Simplify logic:
    // next_state[0] = (in & ~ (s1 & ~s0)) | (~in & s1 & ~s0 & ~s0) ? Let's try Karnaugh map
    // Alternatively, encode per state-in pair:
    // State A (00): next_state = in?01:00 => next_state[0] = in
    // State B (01): next_state = 01 always => next_state[0] = 1
    // State C (10): next_state = in?11:00 => next_state[0] = in
    // State D (11): next_state = in?01:10 => next_state[0] = in?1:0
    // So next_state[0] = (state==B) | (in & (state==A | state==C | state==D))

    wire is_A = (~s1) & (~s0);
    wire is_B = (~s1) & s0;
    wire is_C = s1 & (~s0);
    wire is_D = s1 & s0;

    wire next_state_0 = is_B | (in & (is_A | is_C | is_D));

    assign next_state = {next_state_1, next_state_0};
    assign out = is_D;

endmodule