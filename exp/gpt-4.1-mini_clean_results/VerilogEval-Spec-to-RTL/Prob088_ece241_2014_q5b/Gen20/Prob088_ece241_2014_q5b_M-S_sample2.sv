module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_B;  // one-hot encoding: state_B=0 means A, state_B=1 means B

always @(posedge clk or posedge areset) begin
    if (areset)
        state_B <= 1'b0;  // reset to state A
    else
        state_B <= state_B | x;  // from A: go to B if x=1; from B stay in B
end

always @(*) begin
    z = (~state_B & x) | (state_B & ~x);  // Mealy output
end

endmodule