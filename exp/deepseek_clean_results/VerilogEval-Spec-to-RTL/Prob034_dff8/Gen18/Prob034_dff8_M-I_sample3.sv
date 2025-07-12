module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Clock gating signal - only enable when data changes
wire clk_enable = (d != q);

// Gated clock
wire gated_clk = clk & clk_enable;

// Single always block for all 8 flip-flops
always @(posedge gated_clk) begin
    q <= d;
end

// Initialize all flip-flops to zero
initial begin
    q = 8'b0;
end

endmodule