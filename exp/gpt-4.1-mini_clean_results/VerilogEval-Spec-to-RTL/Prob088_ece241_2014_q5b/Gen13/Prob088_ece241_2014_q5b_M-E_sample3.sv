module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;

// Next state logic (combinational)
wire next_state_A = (state_A & ~x);
wire next_state_B = (~state_A) | (state_B & 1'b1); 
// Alternatively, since from B we stay in B regardless of x, next_state_B = state_B | (state_A & x)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= ~next_state_A;  // Since one-hot, B is complement of A
    end
end

// Output logic (Mealy): from state diagram
// A: z = x
// B: z = ~x
always @(*) begin
    if (state_A)
        z = x;
    else // state_B
        z = ~x;
end

endmodule