module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state signals for each state
    wire next_S0, next_S1, next_S2, next_S3, next_S4, next_S5, next_S6, next_S7, next_S8, next_S9;

    // For clarity, assign state bits to named wires
    wire S0 = state[0];
    wire S1 = state[1];
    wire S2 = state[2];
    wire S3 = state[3];
    wire S4 = state[4];
    wire S5 = state[5];
    wire S6 = state[6];
    wire S7 = state[7];
    wire S8 = state[8];
    wire S9 = state[9];

    // Next state logic:
    // For each state currently active, compute next state based on input
    // Since multiple states can be active, next_state bits are OR of all sources

    // S0 transitions
    // S0 --0--> S0; S0 --1--> S1
    wire nextS0_from_S0 = S0 & (~in);
    wire nextS1_from_S0 = S0 & in;

    // S1 --0--> S0; S1 --1--> S2
    wire nextS0_from_S1 = S1 & (~in);
    wire nextS2_from_S1 = S1 & in;

    // S2 --0--> S0; S2 --1--> S3
    wire nextS0_from_S2 = S2 & (~in);
    wire nextS3_from_S2 = S2 & in;

    // S3 --0--> S0; S3 --1--> S4
    wire nextS0_from_S3 = S3 & (~in);
    wire nextS4_from_S3 = S3 & in;

    // S4 --0--> S0; S4 --1--> S5
    wire nextS0_from_S4 = S4 & (~in);
    wire nextS5_from_S4 = S4 & in;

    // S5 --0--> S8; S5 --1--> S6
    wire nextS8_from_S5 = S5 & (~in);
    wire nextS6_from_S5 = S5 & in;

    // S6 --0--> S9; S6 --1--> S7
    wire nextS9_from_S6 = S6 & (~in);
    wire nextS7_from_S6 = S6 & in;

    // S7 --0--> S0; S7 --1--> S7
    wire nextS0_from_S7 = S7 & (~in);
    wire nextS7_from_S7 = S7 & in;

    // S8 --0--> S0; S8 --1--> S1
    wire nextS0_from_S8 = S8 & (~in);
    wire nextS1_from_S8 = S8 & in;

    // S9 --0--> S0; S9 --1--> S1
    wire nextS0_from_S9 = S9 & (~in);
    wire nextS1_from_S9 = S9 & in;

    // Aggregate next states
    assign next_S0 = nextS0_from_S0 | nextS0_from_S1 | nextS0_from_S2 | nextS0_from_S3 | nextS0_from_S4 |
                     nextS0_from_S7 | nextS0_from_S8 | nextS0_from_S9;

    assign next_S1 = nextS1_from_S0 | nextS1_from_S8 | nextS1_from_S9;

    assign next_S2 = nextS2_from_S1;

    assign next_S3 = nextS3_from_S2;

    assign next_S4 = nextS4_from_S3;

    assign next_S5 = nextS5_from_S4;

    assign next_S6 = nextS6_from_S5;

    assign next_S7 = nextS7_from_S6 | nextS7_from_S7;

    assign next_S8 = nextS8_from_S5;

    assign next_S9 = nextS9_from_S6;

    assign next_state = {next_S9, next_S8, next_S7, next_S6, next_S5, next_S4, next_S3, next_S2, next_S1, next_S0};

    // Output logic from the problem:
    // All outputs zero except:
    // S7: (0,1)
    // S8: (1,0)
    // S9: (1,1)

    assign out1 = S8 | S9;
    assign out2 = S7 | S9;

endmodule