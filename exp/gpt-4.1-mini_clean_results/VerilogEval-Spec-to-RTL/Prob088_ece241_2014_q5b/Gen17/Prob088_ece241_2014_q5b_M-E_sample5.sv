module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states
reg state_A, state_B;

// Next state signals
wire next_state_A;
wire next_state_B;

// Define next state explicitly for each flip-flop
assign next_state_A = state_A & (~x);
assign next_state_B = (state_A & x) | state_B;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output depends on current state and input
always @(*) begin
    if (state_A)
        z = x;
    else
        z = ~x;
end

endmodule