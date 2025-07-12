module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

// Optimized JK flip-flop next state equation
// nextQ = j & ~Q | ~k & Q
assign nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule