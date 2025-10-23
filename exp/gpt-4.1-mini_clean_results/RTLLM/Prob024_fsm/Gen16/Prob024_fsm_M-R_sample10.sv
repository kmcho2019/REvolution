module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding:
    // S0 = state[0] = idle, no match
    // S1 = state[1] = matched '1'
    // S2 = state[2] = matched '10'
    // S3 = state[3] = matched '100'
    // S4 = state[4] = matched '1001'

    reg [4:0] state;

    // Next state signals as wires
    wire next_S0, next_S1, next_S2, next_S3, next_S4;

    // Current state bits for convenience
    wire S0 = state[0];
    wire S1 = state[1];
    wire S2 = state[2];
    wire S3 = state[3];
    wire S4 = state[4];

    // Compute next state logic using parallel assignments

    // From S0 (idle):
    // IN=1 -> S1
    // IN=0 -> S0
    wire s0_to_s1 = S0 & IN;
    wire s0_to_s0 = S0 & ~IN;

    // From S1 (matched '1'):
    // IN=0 -> S2
    // IN=1 -> S1 (restart)
    wire s1_to_s2 = S1 & ~IN;
    wire s1_to_s1 = S1 & IN;

    // From S2 (matched '10'):
    // IN=0 -> S3
    // IN=1 -> S1
    wire s2_to_s3 = S2 & ~IN;
    wire s2_to_s1 = S2 & IN;

    // From S3 (matched '100'):
    // IN=1 -> S4
    // IN=0 -> S0 (reset)
    wire s3_to_s4 = S3 & IN;
    wire s3_to_s0 = S3 & ~IN;

    // From S4 (matched '1001'):
    // IN=1 -> S1 (start new pattern)
    // IN=0 -> S2 (pattern suffix)
    wire s4_to_s1 = S4 & IN;
    wire s4_to_s2 = S4 & ~IN;

    // Combine next state bits from all transitions
    assign next_S0 = s0_to_s0 | s3_to_s0;
    assign next_S1 = s0_to_s1 | s1_to_s1 | s2_to_s1 | s4_to_s1;
    assign next_S2 = s1_to_s2 | s4_to_s2;
    assign next_S3 = s2_to_s3;
    assign next_S4 = s3_to_s4;

    // Sequential logic: state register update
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 5'b00001; // S0 active on reset
        else
            state <= {next_S4, next_S3, next_S2, next_S1, next_S0};
    end

    // Mealy output MATCH = 1 if in S4 and input IN=1 (completes '10011')
    assign MATCH = S4 & IN;

endmodule