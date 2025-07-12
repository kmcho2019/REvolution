module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoding with two state bits
reg state_A, state_B;
wire next_state_A, next_state_B;

// Next state logic - simplified and explicit
assign next_state_A = state_A & ~x;              // Stay in A if x=0
assign next_state_B = (state_A & x) | state_B;  // From A to B if x=1, stay in B

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output logic - continuous assignment replaces combinational always block
assign z = state_A ? x : ~x;

endmodule