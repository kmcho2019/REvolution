module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic optimized using boolean expressions:
    // From the FSM:
    // B(1) --0--> A(0)
    // B(1) --1--> B(1)
    // A(0) --0--> B(1)
    // A(0) --1--> A(0)
    // next_state = (state == B) ? (in ? B : A) : (in ? A : B);
    // Simplify:
    // next_state = (state & in) | (~state & ~in);

    always @(*) begin
        next_state = (state & in) | (~state & ~in);
    end

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from state
    assign out = state;

endmodule