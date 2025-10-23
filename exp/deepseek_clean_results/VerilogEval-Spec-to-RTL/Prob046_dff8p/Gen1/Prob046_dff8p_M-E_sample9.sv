module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Reset value generator
wire [7:0] reset_val;
assign reset_val = 8'b00110100;  // 0x34

// Data selection muxes
wire [7:0] d_in;
assign d_in = reset ? reset_val : d;

// Individual negative-edge DFF instantiations
DFF_NEG dff7 (.clk(clk), .d(d_in[7]), .q(q[7]));
DFF_NEG dff6 (.clk(clk), .d(d_in[6]), .q(q[6]));
DFF_NEG dff5 (.clk(clk), .d(d_in[5]), .q(q[5]));
DFF_NEG dff4 (.clk(clk), .d(d_in[4]), .q(q[4]));
DFF_NEG dff3 (.clk(clk), .d(d_in[3]), .q(q[3]));
DFF_NEG dff2 (.clk(clk), .d(d_in[2]), .q(q[2]));
DFF_NEG dff1 (.clk(clk), .d(d_in[1]), .q(q[1]));
DFF_NEG dff0 (.clk(clk), .d(d_in[0]), .q(q[0]));

endmodule

// Negative-edge triggered D flip-flop module
module DFF_NEG (
    input clk,
    input d,
    output reg q
);
always @(negedge clk) begin
    q <= d;
end
endmodule