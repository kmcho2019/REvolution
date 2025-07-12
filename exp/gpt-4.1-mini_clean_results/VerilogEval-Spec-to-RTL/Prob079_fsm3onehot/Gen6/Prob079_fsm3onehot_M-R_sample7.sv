module TopModule (
    input  wire        in,
    input  wire [3:0]  state,
    output reg  [3:0]  next_state,
    output reg         out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @(*) begin
        // Next state logic based on input and current one-hot state
        next_state[0] = (~in) & (A | C);        // Next A
        next_state[1] = in & (A | B | D);       // Next B
        next_state[2] = (~in) & (B | D);        // Next C
        next_state[3] = in & C;                  // Next D

        // Output depends only on state D
        out = D;
    end

endmodule