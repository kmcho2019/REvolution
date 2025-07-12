module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding
reg state_A, state_B;

// Next state combinational logic
wire next_state_A = state_A & ~x;
wire next_state_B = ~state_A | (state_B & x); // Can also be simplified to ~next_state_A

// Mealy output logic: z=1 when in A and x=1 or in B and x=0
assign z = (state_A & x) | (state_B & ~x);

// Sequential logic with asynchronous active-high reset
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