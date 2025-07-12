module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

wire next_state;

// Combinational next state logic
assign next_state = (~state & b) | (state & ~(a ^ b));

// Output q equals the next state logic (combinational output)
assign q = next_state;

// Sequential state update on positive clock edge
always @(posedge clk) begin
    state <= next_state;
end

endmodule