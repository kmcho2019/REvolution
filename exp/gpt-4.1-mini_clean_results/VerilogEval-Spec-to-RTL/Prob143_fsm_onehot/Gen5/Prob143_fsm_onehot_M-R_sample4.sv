module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define transitions for each current state: next state when in=0 and in=1
    // Format: transitions[current_state][in_value] = next_state_index

    localparam [3:0] trans0 [0:9] = '{ 0, 0, 0, 0, 0, 8, 9, 0, 0, 0 }; // in=0 transitions
    localparam [3:0] trans1 [0:9] = '{ 1, 2, 3, 4, 5, 6, 7, 7, 1, 1 }; // in=1 transitions

    // Internal signals for partial next states for each next_state bit
    wire [9:0] next_state_per_src [0:9];

    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin : gen_next_state_bits
            // For each next state index j, check if it can be reached from current state i
            wire [9:0] partial_next = 10'b0;
            // Determine next state index for in=0 and in=1 at current state i
            wire [3:0] nst0 = trans0[i];
            wire [3:0] nst1 = trans1[i];

            // Generate bits: next_state bit nst0 is set if state[i] & ~in
            //                 next_state bit nst1 is set if state[i] & in
            assign next_state_per_src[i] = 
                  (in ? (10'b1 << nst1) : (10'b1 << nst0)) & {10{state[i]}};
        end
    endgenerate

    // next_state is OR of all partial next state bits from each source state
    assign next_state = next_state_per_src[0] | next_state_per_src[1] | next_state_per_src[2] |
                        next_state_per_src[3] | next_state_per_src[4] | next_state_per_src[5] |
                        next_state_per_src[6] | next_state_per_src[7] | next_state_per_src[8] |
                        next_state_per_src[9];

    // Output logic: out1 = S8 or S9 active; out2 = S7 or S9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule