module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    wire a = (state == A);
    wire b = (state == B);
    wire c = (state == C);
    wire d = (state == D);

    // Next state bit 0 (LSB)
    // From table: 
    // A: next= A(00) if in=0, B(01) if in=1 -> next_state[0] = 0 if in=0, 1 if in=1
    // B: next= C(10) if in=0, B(01) if in=1 -> next_state[0] = 0 if in=0, 1 if in=1
    // C: next= A(00) if in=0, D(11) if in=1 -> next_state[0] = 0 if in=0, 1 if in=1
    // D: next= C(10) if in=0, B(01) if in=1 -> next_state[0] = 0 if in=0, 1 if in=1
    // We can observe next_state[0] = in for B, C, D transitions, but for A:
    // Actually, for A in=0 next_state=00 (bit0=0), in=1 next_state=01 (bit0=1)
    // For all states next_state[0] = in.
    assign next_state[0] = in;

    // Next state bit 1 (MSB)
    // A: next= A(00) if in=0, B(01) if in=1 -> next_state[1] = 0
    // B: next= C(10) if in=0, B(01) if in=1 -> next_state[1] = in ? 0 : 1
    // C: next= A(00) if in=0, D(11) if in=1 -> next_state[1] = in ? 1 : 0
    // D: next= C(10) if in=0, B(01) if in=1 -> next_state[1] = in ? 0 : 1

    // Express next_state[1] in terms of a,b,c,d,in:
    // For a: next_state[1] = 0
    // For b: next_state[1] = ~in
    // For c: next_state[1] = in
    // For d: next_state[1] = ~in

    assign next_state[1] = (b | d) & (~in) | (c & in);

    // Output is 1 only in state D
    assign out = d;

endmodule