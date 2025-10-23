module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;

// Next state logic (combinational)
wire next_state_A = state_A & ~x;
wire next_state_B = state_B | (state_A & x);

// State update with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output logic using continuous assignment for clean synthesis
assign z = (state_A & x) | (state_B & ~x);

endmodule