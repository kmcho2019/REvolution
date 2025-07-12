module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Next state logic with reduced area
    always @(*) begin
        next_state[0] = (state[0] | state[2]) & ~in;  // A <- A or C when in=0
        next_state[1] = (state[0] | state[1] | state[3]) & in;  // B <- A or B or D when in=1
        next_state[2] = (state[1] | state[3]) & ~in;   // C <- B or D when in=0
        next_state[3] = state[2] & in;                 // D <- C when in=1
    end

    // Output logic remains optimally simple
    assign out = state[3]; // Output is 1 only in state D (MSB)

endmodule