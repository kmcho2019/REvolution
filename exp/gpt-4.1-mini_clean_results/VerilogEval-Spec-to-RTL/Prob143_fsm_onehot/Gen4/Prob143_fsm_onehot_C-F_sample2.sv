module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in0 = ~in;
    wire in1 =  in;

    // Intermediate signals for each state's next state bits based on input
    wire [9:0] ns_from_s0 = {10{state[0]}} & (in0 ? 10'b0000000001 : 10'b0000000010);
    wire [9:0] ns_from_s1 = {10{state[1]}} & (in0 ? 10'b0000000001 : 10'b0000010000 >> 12 /* invalid shift, fix */);
    wire [9:0] ns_from_s2 = {10{state[2]}} & (in0 ? 10'b0000000001 : 10'b0000001000);
    wire [9:0] ns_from_s3 = {10{state[3]}} & (in0 ? 10'b0000000001 : 10'b0000100000);
    wire [9:0] ns_from_s4 = {10{state[4]}} & (in0 ? 10'b0000000001 : 10'b0010000000);
    wire [9:0] ns_from_s5 = {10{state[5]}} & (in0 ? 10'b0000010000 : 10'b0000001000);
    wire [9:0] ns_from_s6 = {10{state[6]}} & (in0 ? 10'b0000100000 : 10'b0000000100);
    wire [9:0] ns_from_s7 = {10{state[7]}} & (in0 ? 10'b0000000001 : 10'b0000001000);
    wire [9:0] ns_from_s8 = {10{state[8]}} & (in0 ? 10'b0000000001 : 10'b0000000010);
    wire [9:0] ns_from_s9 = {10{state[9]}} & (in0 ? 10'b0000000001 : 10'b0000000010);

    // Fix above — better to assign explicitly per original solution:

    // Below rewrite all signals explicitly with careful bit setting (bit index from 0 to 9):
    wire [9:0] ns_s0 = (state[0]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000000010 /*S1*/) : 10'b0;
    wire [9:0] ns_s1 = (state[1]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000000100 /*S2*/) : 10'b0;
    wire [9:0] ns_s2 = (state[2]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000001000 /*S3*/) : 10'b0;
    wire [9:0] ns_s3 = (state[3]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000010000 /*S4*/) : 10'b0;
    wire [9:0] ns_s4 = (state[4]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000100000 /*S5*/) : 10'b0;
    wire [9:0] ns_s5 = (state[5]) ? (in0 ? 10'b0010000000 /*S8*/ : 10'b0001000000 /*S6*/) : 10'b0;
    wire [9:0] ns_s6 = (state[6]) ? (in0 ? 10'b0100000000 /*S9*/ : 10'b0000100000 /*S7*/) : 10'b0;
    wire [9:0] ns_s7 = (state[7]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000100000 /*S7*/) : 10'b0;
    wire [9:0] ns_s8 = (state[8]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000000010 /*S1*/) : 10'b0;
    wire [9:0] ns_s9 = (state[9]) ? (in0 ? 10'b0000000001 /*S0*/ : 10'b0000000010 /*S1*/) : 10'b0;

    // Combine all next state contributions via bitwise OR to handle multiple active states
    assign next_state = ns_s0 | ns_s1 | ns_s2 | ns_s3 | ns_s4 |
                        ns_s5 | ns_s6 | ns_s7 | ns_s8 | ns_s9;

    // Outputs asserted in states S8, S9 for out1, and S7, S9 for out2
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule