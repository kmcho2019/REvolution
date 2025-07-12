module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

wire next_Q;

// Minimal and canonical JK flip-flop next state logic
assign next_Q = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule