module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;

// Next state logic
wire next_state_A = state_A & ~x;
wire next_state_B = state_A & x | state_B;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
        z       <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
        // Mealy output logic registered
        z <= (state_A) ? x : ~x;
    end
end

endmodule