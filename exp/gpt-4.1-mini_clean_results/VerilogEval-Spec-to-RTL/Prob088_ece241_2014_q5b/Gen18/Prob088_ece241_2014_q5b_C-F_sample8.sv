module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states: two flip-flops
reg state_A, state_B;
wire next_state_A, next_state_B;

// Next state logic (combinational)
assign next_state_A = state_A & ~x;
assign next_state_B = (state_A & x) | state_B;

// Output logic (Mealy)
assign z = (state_A & x) | (state_B & ~x);

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule