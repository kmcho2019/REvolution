module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // One-hot state decoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @* begin
        // Default next_state to zero to avoid inferred latches
        next_state = 4'b0000;
        out = 1'b0;

        // Next state logic for each bit
        // next_state[0]: next A
        if (~in && (A || C))
            next_state[0] = 1'b1;

        // next_state[1]: next B
        if (in && (A || B || D))
            next_state[1] = 1'b1;

        // next_state[2]: next C
        if (~in && (B || D))
            next_state[2] = 1'b1;

        // next_state[3]: next D
        if (in && C)
            next_state[3] = 1'b1;

        // Moore output: 1 only in state D
        out = D;
    end

endmodule