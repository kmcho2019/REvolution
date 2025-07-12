module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A;

// Next state logic for state_A (combinational)
wire next_state_A = state_A & ~x;

always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;
    else
        state_A <= next_state_A;
end

// State_B is the complement of state_A (one-hot)
wire state_B = ~state_A;

// Output logic (Mealy)
always @(*) begin
    if (state_A)
        z = x;
    else // state_B
        z = ~x;
end

endmodule