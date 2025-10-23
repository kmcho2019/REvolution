module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoding with two state bits
reg state_A, state_B;

// Next state logic signals
wire next_state_A, next_state_B;

// Next state logic
assign next_state_A = (~x & state_A) | (state_A & ~x) /* same logic, simplified */;
assign next_state_B = (x & state_A) | state_B;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // Reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy FSM)
always @(*) begin
    if (state_A)
        z = x ? 1'b1 : 1'b0; // A: z= x
    else // state_B
        z = x ? 1'b0 : 1'b1; // B: z= ~x
end

endmodule