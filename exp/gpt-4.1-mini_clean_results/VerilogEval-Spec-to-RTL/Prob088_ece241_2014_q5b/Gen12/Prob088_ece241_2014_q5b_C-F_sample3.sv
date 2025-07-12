module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states: state_A and state_B
reg state_A, state_B;

// Next state logic (combinational)
wire next_state_A = state_A & ~x;           // stay in A if x=0
wire next_state_B = state_B | (state_A & x); // stay in B or A->B transition

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset to A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output combinational logic: z = (in A) ? x : ~x
// Using continuous assignment for cleaner synthesis
assign z = (state_A) ? x : ~x;

endmodule