module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states as separate regs
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (combinational)
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

// Output logic (Mealy FSM): separate combinational block
always @(*) begin
    if (state_A)
        z = x ? 1'b1 : 1'b0;
    else // state_B
        z = ~x ? 1'b1 : 1'b0;
end

// Clock enable for state_A flip-flop: disable toggling when in state_B (steady state)
wire clk_en_state_A = state_A | (next_state_A != state_A);

// State_A register with clock gating and async reset
reg state_A_ff;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A_ff <= 1'b1;
    end else if (clk_en_state_A) begin
        state_A_ff <= next_state_A;
    end
end
assign state_A = state_A_ff;

// State_B register (always enabled)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_B <= 1'b0;
    end else begin
        state_B <= next_state_B;
    end
end

endmodule