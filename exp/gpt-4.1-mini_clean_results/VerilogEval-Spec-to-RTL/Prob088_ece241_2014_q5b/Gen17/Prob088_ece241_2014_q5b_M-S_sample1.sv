module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;

// Next state logic
wire next_state_A = (state_A & ~x);
wire next_state_B = (~state_A) | (state_B & 1'b1);  // since only two states and B loops on itself

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= ~next_state_A; // complementary since one-hot
    end
end

// Output logic (Mealy)
assign z = (state_A & x) | (state_B & ~x);

endmodule