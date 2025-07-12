module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic using separate assign statements
    assign next_state[0] = (state == A &&!in) | (state == C &&!in) | (state == D &&!in); // Next state bit 0
    assign next_state[1] = (state == A && in) | (state == B && in) | (state == B &&!in) | (state == D && in); // Next state bit 1
    assign next_state[2] = (state == B &&!in) | (state == C && in); // Next state bit 2
    assign next_state[3] = (state == C && in) | (state == D &&!in); // Next state bit 3

    // Output logic
    assign out = (state == D); // Output is 1 when the current state is D

endmodule