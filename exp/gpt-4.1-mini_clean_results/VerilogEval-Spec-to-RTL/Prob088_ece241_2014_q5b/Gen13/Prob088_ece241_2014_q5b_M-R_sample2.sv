module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding
reg state_A, state_B;

// Next state signals
wire next_state_A;
wire next_state_B;

// Next state logic
assign next_state_A = state_A & ~x;
assign next_state_B = (~state_A) | (state_A & x);

// Output logic (Mealy output)
assign z = (state_A & x) | (state_B & ~x);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule