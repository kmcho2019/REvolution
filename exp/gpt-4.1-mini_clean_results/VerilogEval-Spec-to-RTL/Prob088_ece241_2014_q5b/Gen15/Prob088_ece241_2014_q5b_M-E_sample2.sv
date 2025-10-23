module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;

// Next state logic signals
wire next_state_A;
wire next_state_B;

assign next_state_A = state_A & ~x; // Stay in A if x=0, else move to B
assign next_state_B = (state_A & x) | state_B; // Move to B if from A and x=1, or stay in B

// Output logic (Mealy): z=1 when in A and x=1, or in B and x=0
assign z = (state_A & x) | (state_B & ~x);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule