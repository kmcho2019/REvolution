module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded state bits
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (combinational)
always @(*) begin
    // From state A: if x=0 stay in A, if x=1 go to B
    // From state B: stay in B regardless of x
    next_state_A = state_A & ~x;
    next_state_B = (state_A & x) | state_B;
end

// Output logic (Mealy)
always @(*) begin
    // When in A, z = x; when in B, z = ~x
    if (state_A)
        z = x;
    else
        z = ~x;
end

// State register with asynchronous active-high reset
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