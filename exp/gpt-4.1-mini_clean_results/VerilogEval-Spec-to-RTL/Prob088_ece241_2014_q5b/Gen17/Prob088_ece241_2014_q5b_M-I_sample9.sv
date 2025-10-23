module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset to state A (one-hot)
        z       <= 1'b0;  // Output default at reset (z=0 at state A and x=0)
    end else begin
        // Next state logic: stay in A if x=0; else move to B (state_A=0)
        state_A <= state_A & ~x;
        
        // Output logic: Mealy output depends on current state and input x
        // From FSM: z = (A & x) | (B & ~x) = (state_A & x) | (~state_A & ~x)
        z <= (state_A & x) | (~state_A & ~x);
    end
end

endmodule