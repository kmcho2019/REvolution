// Module for a single D flip-flop
module DFF(
    input clk,
    input d,
    output logic q
);

always @(posedge clk) begin
    q <= d; // Non-blocking assignment for sequential logic
end

endmodule

// TopModule using the DFF module for each bit
module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

// Instantiate DFF module for each bit of 'd' and 'q'
DFF dff_0(.clk(clk), .d(d[0]), .q(q[0]));
DFF dff_1(.clk(clk), .d(d[1]), .q(q[1]));
DFF dff_2(.clk(clk), .d(d[2]), .q(q[2]));
DFF dff_3(.clk(clk), .d(d[3]), .q(q[3]));
DFF dff_4(.clk(clk), .d(d[4]), .q(q[4]));
DFF dff_5(.clk(clk), .d(d[5]), .q(q[5]));
DFF dff_6(.clk(clk), .d(d[6]), .q(q[6]));
DFF dff_7(.clk(clk), .d(d[7]), .q(q[7]));

endmodule