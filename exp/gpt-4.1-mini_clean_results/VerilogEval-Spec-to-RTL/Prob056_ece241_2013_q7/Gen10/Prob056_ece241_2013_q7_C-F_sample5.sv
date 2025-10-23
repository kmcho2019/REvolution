module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

wire nextQ;

// Minimal, canonical JK flip-flop characteristic equation
assign nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule