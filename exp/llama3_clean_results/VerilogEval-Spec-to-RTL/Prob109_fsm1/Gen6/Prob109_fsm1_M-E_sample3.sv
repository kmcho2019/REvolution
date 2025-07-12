module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [1:0] state; // One-hot encoding: 01 - state A, 10 - state B
reg [1:0] next_state;

// Initialize state to B on reset
initial state = 2'b10;

// Combinational logic to determine next state
always @(*)
begin
    case (state)
        2'b01: next_state = in? 2'b01 : 2'b10; // Stay in A on 1, go to B on 0
        2'b10: next_state = in? 2'b10 : 2'b01; // Stay in B on 1, go to A on 0
        default: next_state = 2'b10; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 2'b10; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state[1]; // Output is 1 when in state B

endmodule