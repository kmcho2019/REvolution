module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

wire next_Q;

// Minimal JK flip-flop characteristic function:
// When J=K=0, hold Q
// When J=0, K=1, reset to 0
// When J=1, K=0, set to 1
// When J=K=1, toggle Q
assign next_Q = (j & ~k) | (j & k & ~Q) | (Q & ~j & ~k);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule