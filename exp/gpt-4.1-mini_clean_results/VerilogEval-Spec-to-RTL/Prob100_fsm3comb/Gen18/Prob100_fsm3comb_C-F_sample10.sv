module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Explicit combinational logic for next_state bits:
    // From the state table:
    // next_state[1]:
    //   A(00): in=0 -> A(00), in=1 -> B(01) => next_state[1] = 0 for both cases
    //   B(01): in=0 -> C(10), in=1 -> B(01) => next_state[1] = in==0?1:0
    //   C(10): in=0 -> A(00), in=1 -> D(11) => next_state[1] = in==1?1:0
    //   D(11): in=0 -> C(10), in=1 -> B(01) => next_state[1] = in==0?1:0

    // next_state[0]:
    //   A(00): in=0 -> A(00), in=1 -> B(01) => next_state[0] = in
    //   B(01): in=0 -> C(10), in=1 -> B(01) => next_state[0] = in==0?0:1
    //   C(10): in=0 -> A(00), in=1 -> D(11) => next_state[0] = in==0?0:1
    //   D(11): in=0 -> C(10), in=1 -> B(01) => next_state[0] = in==0?0:1

    // Define wires for clarity
    wire s0 = state[0];
    wire s1 = state[1];

    // Logic derived by inspecting the table:
    // next_state[1] = (~s1 & s0 & ~in) | (s1 & ~s0 & in) | (s1 & s0 & ~in);
    // Simplify terms:
    // next_state[1] = (B & in=0) | (C & in=1) | (D & in=0)
    // B = 01, C = 10, D = 11

    // next_state[0] = ( (~s1 & ~s0 & in) )  // from A
    //               | ( (~s1 & s0 & in) )   // from B
    //               | ( (s1 & ~s0 & in) )   // from C
    //               | ( (s1 & s0 & in==0 ?0:1)) but better as:
    // Actually, next_state[0] = in & (state == A or state == B or state == C) + 0 if D and in=0, 1 if in=1 (from table)
    // From the table, next_state[0] is 1 if in=1 except state D/in=0

    // Let's express next_state bits:

    assign next_state[1] = ( (~s1 &  s0 & ~in) // B and in=0
                          | ( s1 & ~s0 &  in) // C and in=1
                          | ( s1 &  s0 & ~in) // D and in=0
                          );

    assign next_state[0] = ( (~s1 & ~s0 &  in)  // A and in=1
                          | (~s1 &  s0 &  in)  // B and in=1
                          | ( s1 & ~s0 &  in)  // C and in=1
                          | ( s1 &  s0 &  in)  // D and in=1
                          );

    // Output is 1 only in state D (11)
    assign out = (state == D);

endmodule