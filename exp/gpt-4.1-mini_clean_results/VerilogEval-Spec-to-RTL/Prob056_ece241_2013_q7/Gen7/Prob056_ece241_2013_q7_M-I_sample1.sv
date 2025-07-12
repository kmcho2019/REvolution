module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

// Minimized Boolean expression for JK flip-flop next state
assign next_Q = (j & ~k) | (j & k & ~Q) | (~j & ~k & Q);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule