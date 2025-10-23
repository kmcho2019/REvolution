module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Common sub-expressions
    wire state0_in = state[0] & in;
    wire state1_in = state[1] & in;
    wire state2_in = state[2] & in;
    wire state3_in = state[3] & in;
    wire state1_nin = state[1] & ~in;
    wire state3_nin = state[3] & ~in;

    // Optimized next state logic
    always @(*) begin
        next_state[0] = (state[0] | state[2]) & ~in;  // A <- A(in=0) or C(in=0)
        next_state[1] = state0_in | state1_in | state3_in;  // B <- A(in=1) or B(in=1) or D(in=1)
        next_state[2] = state1_nin | state3_nin;      // C <- B(in=0) or D(in=0)
        next_state[3] = state2_in;                    // D <- C(in=1)
    end

    // Output logic remains optimally simple
    assign out = state[3]; // Output is 1 only in state D (MSB)

endmodule