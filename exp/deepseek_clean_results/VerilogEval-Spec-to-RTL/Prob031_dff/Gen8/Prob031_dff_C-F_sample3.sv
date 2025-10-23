module TopModule (
    input clk,
    input d,
    output reg q
);

// Positive edge-triggered D flip-flop
// Stores input 'd' on each rising clock edge
always @(posedge clk) begin
    q <= d;
end

endmodule