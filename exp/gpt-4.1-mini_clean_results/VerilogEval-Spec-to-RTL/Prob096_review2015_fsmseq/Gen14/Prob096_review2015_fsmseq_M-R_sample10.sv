module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding: 5 states (S0-S4)
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next state logic with one-hot encoding
    // S0: waiting for '1' to go to S1 else stay in S0
    wire s0_next = (~state[0] & ~state[1] & ~state[2] & ~state[3] & ~state[4]); // not used explicitly
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];

    // Next state combinational assignments:
    // From S0
    wire next_s1 = s0 & data;
    wire next_s0 = s0 & (~data);

    // From S1
    wire next_s2 = s1 & data;
    wire next_s0_1 = s1 & (~data);

    // From S2
    wire next_s2_1 = s2 & data;
    wire next_s3 = s2 & (~data);

    // From S3
    wire next_s4 = s3 & data;
    wire next_s0_3 = s3 & (~data);

    // From S4 (sticky)
    wire next_s4_sticky = s4;

    // Combine next state bits
    assign next_state[0] = next_s0 | next_s0_1 | next_s0_3; // S0 next
    assign next_state[1] = next_s1;                         // S1 next
    assign next_state[2] = next_s2 | next_s2_1;            // S2 next
    assign next_state[3] = next_s3;                         // S3 next
    assign next_state[4] = next_s4 | next_s4_sticky;       // S4 next (sticky)

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output is high when in S4 (sticky detection)
    assign start_shifting = state[4];

endmodule