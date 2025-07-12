module TopModule(
    input       in,
    input [1:0] state,
    output [1:0] next_state,
    output       out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Output depends only on current state (Moore output)
    assign out = (state == D) ? 1'b1 : 1'b0;

    // Next state logic using combinational expressions
    // Decode state bits for readability
    wire state0 = state[0];
    wire state1 = state[1];

    // Using logic from transition table:
    // next_state[1]:
    // A=00 -> next_state=00 or 01 => MSB=0
    // B=01 -> next_state=10 or 01 => next_state[1] = ~in & 1 + 0 = ~in
    // C=10 -> next_state=00 or 11 => next_state[1] = in (since 11 -> MSB=1)
    // D=11 -> next_state=10 or 01 => next_state[1] = ~in
    //
    // next_state[0]:
    // A=00 -> next_state=00 or 01 => LSB = in
    // B=01 -> next_state=10 or 01 => LSB = ~in
    // C=10 -> next_state=00 or 11 => LSB = in
    // D=11 -> next_state=10 or 01 => LSB = ~in
    //
    // From this, derive next_state bits as expressions:

    // next_state[1] = (~state1 & state0 & ~in) | (state1 & ~state0 & in) | (state1 & state0 & ~in)
    // Simplify: next_state[1] = ( (state == B) & ~in ) | ( (state == C) & in ) | ( (state == D) & ~in )
    // Next_state[0] = ( (~state1 & ~state0 & in) ) | ( (~state1 & state0 & ~in) ) | ( (state1 & ~state0 & in) ) | ( (state1 & state0 & ~in) )
    // This is more complex but can be expressed as:

    wire is_A = (state == A);
    wire is_B = (state == B);
    wire is_C = (state == C);
    wire is_D = (state == D);

    assign next_state[1] = (is_B & ~in) | (is_C & in) | (is_D & ~in);

    assign next_state[0] = (is_A & in) | (is_B & ~in) | (is_C & in) | (is_D & ~in);

endmodule