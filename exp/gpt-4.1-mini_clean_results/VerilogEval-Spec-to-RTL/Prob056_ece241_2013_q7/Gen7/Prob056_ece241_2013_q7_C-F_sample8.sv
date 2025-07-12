module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

// Minimal characteristic equation for JK flip-flop next state
assign nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule