module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot state encoding
    // Each bit represents a unique state:
    // state[0] = S0 (000)
    // state[1] = S1 (001)
    // state[2] = S2 (010)
    // state[3] = S3 (011)
    // state[4] = S4 (100)
    reg [4:0] state, next_state;

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    // Combinational next state logic based on current one-hot state and input x
    always @(*) begin
        // Default no transitions
        next_state = 5'b00000;

        case (1'b1) // priority encoding on one-hot state bits
            state[0]: next_state = x ? 5'b00010 : 5'b00001; // S0 -> S1 if x=1 else S0
            state[1]: next_state = x ? 5'b10000 : 5'b00010; // S1 -> S4 if x=1 else S1 (fix per spec: S1 next states are 001->001 if x=0, 100 if x=1, so S1->S1 for x=0)
            state[2]: next_state = x ? 5'b00010 : 5'b00100; // S2 -> S1 if x=1 else S2
            state[3]: next_state = x ? 5'b00100 : 5'b00010; // S3 -> S2 if x=1 else S1
            state[4]: next_state = x ? 5'b10000 : 5'b01000; // S4 -> S4 if x=1 else S3
            default: next_state = 5'b00001; // default to S0
        endcase
    end

    // Output logic: z=1 when in states S3 or S4
    assign z = state[3] | state[4];

endmodule