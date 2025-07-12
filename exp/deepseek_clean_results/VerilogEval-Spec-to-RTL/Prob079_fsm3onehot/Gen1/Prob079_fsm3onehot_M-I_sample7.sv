module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Next state logic optimized for one-hot encoding
    always @(*) begin
        next_state[0] = (state[0] & ~in) | (state[2] & ~in);  // A <- A(in=0) or C(in=0)
        next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);  // B <- A(in=1) or B(in=1) or D(in=1)
        next_state[2] = (state[1] & ~in) | (state[3] & ~in);   // C <- B(in=0) or D(in=0)
        next_state[3] = (state[2] & in);                       // D <- C(in=1)
    end

    // Output logic remains optimally simple
    assign out = state[3]; // Output is 1 only in state D (MSB)

endmodule