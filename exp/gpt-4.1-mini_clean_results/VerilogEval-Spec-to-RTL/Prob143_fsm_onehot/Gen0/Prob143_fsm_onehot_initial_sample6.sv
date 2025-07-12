module TopModule (
    input  wire        in,
    input  wire [9:0]  state,
    output wire [9:0]  next_state,
    output wire        out1,
    output wire        out2
);

    // Define next_state bits for each state conditionally depending on 'in'
    wire [9:0] ns;

    // For state S0 (state[0])
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];
    wire s5 = state[5];
    wire s6 = state[6];
    wire s7 = state[7];
    wire s8 = state[8];
    wire s9 = state[9];

    // Next state logic:
    // S0 (0,0): 0->S0, 1->S1
    wire [9:0] ns_s0 = {10{ s0 & ~in }} & 10'b0000000001  // 0->S0 (bit0)
                     | {10{ s0 &  in }} & 10'b0000000010; // 1->S1 (bit1)

    // S1 (0,0): 0->S0, 1->S2
    wire [9:0] ns_s1 = {10{ s1 & ~in }} & 10'b0000000001 // S0
                     | {10{ s1 &  in }} & 10'b0000000100; // S2

    // S2 (0,0): 0->S0, 1->S3
    wire [9:0] ns_s2 = {10{ s2 & ~in }} & 10'b0000000001 // S0
                     | {10{ s2 &  in }} & 10'b0000001000; // S3

    // S3 (0,0): 0->S0, 1->S4
    wire [9:0] ns_s3 = {10{ s3 & ~in }} & 10'b0000000001 // S0
                     | {10{ s3 &  in }} & 10'b0000010000; // S4

    // S4 (0,0): 0->S0, 1->S5
    wire [9:0] ns_s4 = {10{ s4 & ~in }} & 10'b0000000001 // S0
                     | {10{ s4 &  in }} & 10'b0000100000; // S5

    // S5 (0,0): 0->S8, 1->S6
    wire [9:0] ns_s5 = {10{ s5 & ~in }} & 10'b0010000000 // S8
                     | {10{ s5 &  in }} & 10'b0001000000; // S6

    // S6 (0,0): 0->S9, 1->S7
    wire [9:0] ns_s6 = {10{ s6 & ~in }} & 10'b0100000000 // S9
                     | {10{ s6 &  in }} & 10'b1000000000; // S7

    // S7 (0,1): 0->S0, 1->S7
    // Note: for outputs, state S7 has out2=1
    // For next state, input 0 -> S0, input 1 -> S7 (itself)
    wire s7_out2 = s7; // Out2 is 1 when in S7 active
    wire [9:0] ns_s7 = {10{ s7 & ~in }} & 10'b0000000001 // S0
                     | {10{ s7 &  in }} & 10'b1000000000; // S7

    // S8 (1,0): 0->S0, 1->S1
    // For outputs, state S8 has out1=1
    wire s8_out1 = s8;
    wire [9:0] ns_s8 = {10{ s8 & ~in }} & 10'b0000000001 // S0
                     | {10{ s8 &  in }} & 10'b0000000010; // S1

    // S9 (1,1): 0->S0, 1->S1
    // For outputs, state S9 has out1=1 and out2=1
    wire s9_out1 = s9;
    wire s9_out2 = s9;
    wire [9:0] ns_s9 = {10{ s9 & ~in }} & 10'b0000000001 // S0
                     | {10{ s9 &  in }} & 10'b0000000010; // S1

    // Combine all next states with OR (since multiple states can be active)
    assign next_state = ns_s0 | ns_s1 | ns_s2 | ns_s3 | ns_s4 | ns_s5 | ns_s6 | ns_s7 | ns_s8 | ns_s9;

    // Outputs are OR of output conditions from all active states
    assign out1 = s8_out1 | s9_out1;
    assign out2 = s7_out2 | s9_out2;

endmodule