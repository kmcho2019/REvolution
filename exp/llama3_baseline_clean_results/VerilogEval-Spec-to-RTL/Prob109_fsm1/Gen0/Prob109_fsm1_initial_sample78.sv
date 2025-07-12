module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// Combinational logic for next state and output
always_comb begin
    case(state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B; // default state
    endcase
    out = state; // output is the current state
end

// Sequential logic for state update
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= B; // asynchronous reset to state B
    else state <= next_state;
end

endmodule