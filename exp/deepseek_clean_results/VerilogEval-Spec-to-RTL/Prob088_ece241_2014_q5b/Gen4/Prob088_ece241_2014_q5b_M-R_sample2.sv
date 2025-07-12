module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers (A=01, B=10)
    reg [1:0] state;

    // Continuous assignments for next state
    wire [1:0] next_state = areset ? 2'b01 : 
                          (state[0] ? {x, ~x} : {1'b1, 1'b0});

    // Output logic
    assign z = state[0] ? x : ~x;

    // State transition with async reset
    always @(posedge clk or posedge areset)
        state <= next_state;

endmodule