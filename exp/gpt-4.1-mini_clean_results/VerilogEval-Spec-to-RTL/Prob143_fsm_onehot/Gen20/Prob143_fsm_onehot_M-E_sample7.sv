module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Generate next state vectors for each state depending on input
    wire [9:0] ns_s0  = in  ? 10'b0000000010 : 10'b0000000001; // S0 -> S1 (in=1), S0 (in=0)
    wire [9:0] ns_s1  = in  ? 10'b0000000100 : 10'b0000000001; // S1 -> S2 (in=1), S0 (in=0)
    wire [9:0] ns_s2  = in  ? 10'b0000001000 : 10'b0000000001; // S2 -> S3 (in=1), S0 (in=0)
    wire [9:0] ns_s3  = in  ? 10'b0000010000 : 10'b0000000001; // S3 -> S4 (in=1), S0 (in=0)
    wire [9:0] ns_s4  = in  ? 10'b0000100000 : 10'b0000000001; // S4 -> S5 (in=1), S0 (in=0)
    wire [9:0] ns_s5  = in  ? 10'b000001000000 : 10'b0000000100000000; // Wait, too long: need correction

    // Fix the 10-bit binary representation carefully
    // State indices: S0=0, S1=1, S2=2, ..., S9=9
    
    // Re-define ns_s5 carefully:
    // S5 (index 5): 
    // in=0 -> S8 (index 8)
    // in=1 -> S6 (index 6)
    wire [9:0] ns_s5  = in ? 10'b0000010000 /* 1<<6 = 0x40 */ : 10'b100000000 /* 1<<8 = 0x100 */;

    // Similarly, ns_s6:
    // S6 (index 6):
    // in=0 -> S9 (index 9)
    // in=1 -> S7 (index 7)
    wire [9:0] ns_s6  = in ? 10'b0001000000 /* 1<<7 = 0x80 */ : 10'b1000000000 /* 1<<9 = 0x200 */;

    // ns_s7:
    // S7 (index 7):
    // in=0 -> S0 (index 0)
    // in=1 -> S7 (index 7)
    wire [9:0] ns_s7  = in ? 10'b0001000000 /* 1<<7 */ : 10'b0000000001 /* 1<<0 */;

    // ns_s8:
    // S8 (index 8):
    // in=0 -> S0 (index 0)
    // in=1 -> S1 (index 1)
    wire [9:0] ns_s8  = in ? 10'b0000000010 /* 1<<1 */ : 10'b0000000001 /* 1<<0 */;

    // ns_s9:
    // S9 (index 9):
    // in=0 -> S0 (index 0)
    // in=1 -> S1 (index 1)
    wire [9:0] ns_s9  = in ? 10'b0000000010 /* 1<<1 */ : 10'b0000000001 /* 1<<0 */;

    // Combine next states from all active current states
    assign next_state = 
          (state[0] ? ns_s0 : 10'b0)
        | (state[1] ? ns_s1 : 10'b0)
        | (state[2] ? ns_s2 : 10'b0)
        | (state[3] ? ns_s3 : 10'b0)
        | (state[4] ? ns_s4 : 10'b0)
        | (state[5] ? ns_s5 : 10'b0)
        | (state[6] ? ns_s6 : 10'b0)
        | (state[7] ? ns_s7 : 10'b0)
        | (state[8] ? ns_s8 : 10'b0)
        | (state[9] ? ns_s9 : 10'b0);

    // Output logic:
    // out1 = 1 if S8 or S9 active
    // out2 = 1 if S7 or S9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule