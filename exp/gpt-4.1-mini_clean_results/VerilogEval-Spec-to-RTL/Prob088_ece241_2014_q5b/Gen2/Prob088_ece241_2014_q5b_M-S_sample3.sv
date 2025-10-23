module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    reg state; // one-hot: 1 = A, 0 = B

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // state A
        else
            state <= (state & ~x) | (~state); // next state logic: A->A if x=0 else B, B->B

        // Explanation:
        // From A(1): next_state = x ? 0 (B) : 1 (A)
        // From B(0): next_state = 0 (B)
    end

    // Mealy output logic
    always @(*) begin
        z = (state & x) | (~state & ~x);
        // A and x=1 => z=1
        // B and x=0 => z=1
        // Else z=0
    end

endmodule