module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;
wire next_state_A, next_state_B;

// Next state logic
assign next_state_A = state_A & ~x;
assign next_state_B = (~state_A & ~state_B) | (state_B & 1'b1) | (state_A & x);

// Simplify next_state_B: since only two states, next_state_B = ~next_state_A
// But to avoid direct complement, define explicitly as:
assign next_state_B = ~next_state_A;

// Output logic: Mealy output depends on state and input
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