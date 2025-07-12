module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Next state logic for each possible current state
    wire [9:0] next_S0 = in ? 10'b0000000010 : 10'b0000000001;
    wire [9:0] next_S1 = in ? 10'b0000000100 : 10'b0000000001;
    wire [9:0] next_S2 = in ? 10'b0000001000 : 10'b0000000001;
    wire [9:0] next_S3 = in ? 10'b0000010000 : 10'b0000000001;
    wire [9:0] next_S4 = in ? 10'b0000100000 : 10'b0000000001;
    wire [9:0] next_S5 = in ? 10'b0001000000 : 10'b0010000000;
    wire [9:0] next_S6 = in ? 10'b0100000000 : 10'b1000000000;
    wire [9:0] next_S7 = in ? 10'b0100000000 : 10'b0000000001;
    wire [9:0] next_S8 = in ? 10'b0000000010 : 10'b0000000001;
    wire [9:0] next_S9 = in ? 10'b0000000010 : 10'b0000000001;

    // Combine next states from all possible current states
    assign next_state = 
        (state[0] ? next_S0 : 10'b0) |
        (state[1] ? next_S1 : 10'b0) |
        (state[2] ? next_S2 : 10'b0) |
        (state[3] ? next_S3 : 10'b0) |
        (state[4] ? next_S4 : 10'b0) |
        (state[5] ? next_S5 : 10'b0) |
        (state[6] ? next_S6 : 10'b0) |
        (state[7] ? next_S7 : 10'b0) |
        (state[8] ? next_S8 : 10'b0) |
        (state[9] ? next_S9 : 10'b0);

    // Output logic
    assign out1 = |(state & 10'b0110000000);  // S8 or S9
    assign out2 = |(state & 10'b1100000000);  // S7 or S9

endmodule