module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// Single one-hot state bit: state_B = 1 means in state B; state_A implied when state_B=0
reg state_B;

// Next state logic
wire next_state_B = (state_B) || (x && ~state_B);

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_B <= 1'b0;  // Reset into state A (state_B=0)
    else
        state_B <= next_state_B;
end

// Output logic (Mealy FSM)
always @(*) begin
    if (!state_B)
        z = x;      // In state A, z = x
    else
        z = ~x;     // In state B, z = ~x
end

endmodule