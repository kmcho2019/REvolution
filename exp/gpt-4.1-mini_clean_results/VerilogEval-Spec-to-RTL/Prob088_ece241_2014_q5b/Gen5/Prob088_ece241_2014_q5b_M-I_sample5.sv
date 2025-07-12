module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoding: state_A and state_B, only one active at a time
reg state_A, state_B;

// Next state signals
wire next_state_A;
wire next_state_B;

// Next state logic based on current states and input x
assign next_state_A = (state_A && ~x) || (state_B && 1'b0); // From B there is no transition back to A
assign next_state_B = (state_A && x) || (state_B);

// Sequential logic: asynchronous active-high reset, positive edge clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy FSM) as continuous assignment for minimal combinational logic
assign z = (state_A & x) | (state_B & ~x);

endmodule