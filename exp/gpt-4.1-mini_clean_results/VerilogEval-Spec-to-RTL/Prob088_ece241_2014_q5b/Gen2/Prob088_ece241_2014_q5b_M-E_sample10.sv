module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state combinational logic
always @(*) begin
    if (state_A) begin
        // From A: if x=0 stay in A; if x=1 go to B
        next_state_A = ~x;
        next_state_B = x;
    end else begin
        // From B: stay in B regardless of x
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end
end

// Output logic (Mealy FSM)
assign z = (state_A && x) || (state_B && ~x);

// State registers with asynchronous active-high reset
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