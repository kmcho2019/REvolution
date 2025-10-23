module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Binary state encoding: one flip-flop
    // 0 = A, 1 = B
    reg state;

    // Next state logic
    wire next_state = (state == 1'b0) ? x : 1'b1;

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to state A
        else
            state <= next_state;
    end

    // Output logic (Mealy)
    // A: z = x; B: z = ~x
    assign z = (state == 1'b0) ? x : ~x;

endmodule