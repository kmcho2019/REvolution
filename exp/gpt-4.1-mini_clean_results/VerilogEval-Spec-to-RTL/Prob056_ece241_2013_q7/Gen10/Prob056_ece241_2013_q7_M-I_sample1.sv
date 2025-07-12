module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

// Simplified JK flip-flop next state equation:
// Q(next) = J & ~Q + ~K & Q
assign nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule