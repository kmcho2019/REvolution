module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: 0 = B, 1 = A
    reg state;
    wire next_state;

    // Next state logic from the diagram:
    // B(0) --0--> A(1)
    // B(0) --1--> B(0)
    // A(1) --0--> B(0)
    // A(1) --1--> A(1)
    assign next_state = (state & in) | (~state & ~in);

    // Asynchronous reset to state B (0)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to B
        else
            state <= next_state;
    end

    // Output is 1 when in state B (0), else 0
    assign out = ~state;

endmodule