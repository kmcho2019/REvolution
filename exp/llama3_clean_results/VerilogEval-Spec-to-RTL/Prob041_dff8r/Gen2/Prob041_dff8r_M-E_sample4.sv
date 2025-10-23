// Define a module for a single D flip-flop with synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule that instantiates 8 DFF modules
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFF modules
DFF dff0(.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));
DFF dff1(.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
DFF dff2(.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
DFF dff3(.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
DFF dff4(.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
DFF dff5(.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
DFF dff6(.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
DFF dff7(.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));

endmodule