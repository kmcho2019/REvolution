module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;

// Clock gating for reset functionality
assign gated_clk = r ? 1'b0 : clk;

// Simple D flip-flop without reset
always @(posedge gated_clk) begin
    q <= d;
end

// Force output to 0 during reset
assign q = r ? 1'b0 : q;

endmodule