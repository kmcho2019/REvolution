module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding: each state is a bit vector with only one bit set
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic simplified by one-hot encoding
    always @(*) begin
        // default next_state zero to avoid latches
        next_state = 4'b0000;
        case(1'b1) // one-hot encoded state decoding
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default:  next_state = A; // safety default
        endcase
    end

    // Output logic: output is 1 only in state D, otherwise 0
    always @(*) begin
        out = state[D];
    end

endmodule