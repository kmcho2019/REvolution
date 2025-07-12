module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state vector: bit 0 for A, bit 1 for B
reg [1:0] state, next_state;

// Next state logic (simplified)
always @(*) begin
    case (state)
        2'b01: next_state = x ? 2'b10 : 2'b01; // A state
        2'b10: next_state = 2'b10;              // B state stays on B
        default: next_state = 2'b01;            // Default to state A for safety
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;  // Reset into state A (one-hot)
    else
        state <= next_state;
end

// Output logic (Mealy FSM) as continuous assignment
assign z = (state[0]) ? x : (~x);

endmodule