module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding for clarity
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Minimal next-state logic using XOR: next_state = state XOR NOT(in)
    // Matches the FSM transitions:
    // B(1) --0--> A(0), B(1) --1--> B(1)
    // A(0) --0--> B(1), A(0) --1--> A(0)
    assign next_state = state ^ ~in;

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Registered Moore output to reduce glitches and improve power
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;  // output for state B
        else
            out <= (state == A) ? 1'b0 : 1'b1;
    end

endmodule