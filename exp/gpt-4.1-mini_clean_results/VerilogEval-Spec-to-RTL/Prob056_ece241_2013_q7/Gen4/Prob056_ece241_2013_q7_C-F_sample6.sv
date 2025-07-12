module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

// Minimal and clear JK flip-flop next state logic
assign nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule