module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding bits
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic using one-hot encoding
    // next_state[A] = (state[A] & ~in) | (state[C] & ~in);
    // next_state[B] = (state[A] & in) | (state[B] & in) | (state[D] & in);
    // next_state[C] = (state[B] & ~in) | (state[D] & ~in);
    // next_state[D] = (state[C] & in);
    //
    // These logic equations directly implement the transition table.

    wire a, b, c, d;
    assign a = (state[0] & ~in) | (state[2] & ~in);
    assign b = (state[0] & in) | (state[1] & in) | (state[3] & in);
    assign c = (state[1] & ~in) | (state[3] & ~in);
    assign d = (state[2] & in);

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= {d, c, b, a};  // {D,C,B,A} MSB to LSB
    end

    // Output is 1 only in state D (bit 3)
    assign out = state[3];

endmodule