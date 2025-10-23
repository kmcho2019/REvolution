module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding: B=1, A=0
    reg state, next_state;

    // Next state logic using boolean expression:
    // From diagram:
    // If state = B(1):
    //   in=0 -> A(0)
    //   in=1 -> B(1)
    // If state = A(0):
    //   in=0 -> B(1)
    //   in=1 -> A(0)
    //
    // next_state = (state & in) | (~state & ~in)
    always @(*) begin
        next_state = (state & in) | (~state & ~in);
    end

    // State register with asynchronous reset to B (1)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // B
        else
            state <= next_state;
    end

    // Output register (Moore machine output depends only on state)
    // B=1 -> out=1; A=0 -> out=0
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;
        else
            out <= state;
    end

endmodule