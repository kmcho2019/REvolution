module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A;

// Next state logic
wire next_state_A = state_A & ~x;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;  // reset to state A
    else
        state_A <= next_state_A;
end

// Mealy output logic using continuous assignment
assign z = state_A ? x : ~x;

endmodule