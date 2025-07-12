module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state; // 0 = A, 1 = B
    wire next_state;

    // Next state logic
    // A(0): if x=1 -> B(1), else A(0)
    // B(1): always B(1)
    assign next_state = (state == 0) ? x : 1'b1;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // Reset to A
        else
            state <= next_state;
    end

    // Output logic (Mealy)
    // In A(state=0): z = x
    // In B(state=1): z = ~x
    assign z = (state == 0) ? x : ~x;

endmodule