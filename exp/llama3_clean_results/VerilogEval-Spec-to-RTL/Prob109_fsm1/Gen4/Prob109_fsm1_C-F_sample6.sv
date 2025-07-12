module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

// Define the states using enum for better readability
enum logic [0:0] {
    A = 0,
    B = 1
} state, next_state;

// Combinational logic to determine next state
always_comb begin
    case(state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B; // Default to state B
    endcase
end

// Sequential logic to update current state with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= B; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule