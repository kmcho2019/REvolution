module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;

// Next state logic
wire next_state_A = (state_A & ~x);  // From A, stay in A if x=0
wire next_state_B = (~state_A) | (state_A & x); // From A to B if x=1, or stay in B

// Output logic (Mealy)
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