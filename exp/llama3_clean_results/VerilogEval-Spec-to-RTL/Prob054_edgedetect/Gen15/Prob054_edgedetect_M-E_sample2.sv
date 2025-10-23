// Define a single-bit edge detection module
module EdgeDetect(
    input clk,
    input in,
    output out
);

reg prev_in;  // register to store the previous state of the input

always @(posedge clk) begin
    // update the previous state
    prev_in <= in;
    
    // detect edge and update the output
    out <= in & ~prev_in;
end

endmodule

// Define the top-level module
module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Instantiate the edge detection module for each bit in the input vector
EdgeDetect edge0 (.clk(clk), .in(in[0]), .out(pedge[0]));
EdgeDetect edge1 (.clk(clk), .in(in[1]), .out(pedge[1]));
EdgeDetect edge2 (.clk(clk), .in(in[2]), .out(pedge[2]));
EdgeDetect edge3 (.clk(clk), .in(in[3]), .out(pedge[3]));
EdgeDetect edge4 (.clk(clk), .in(in[4]), .out(pedge[4]));
EdgeDetect edge5 (.clk(clk), .in(in[5]), .out(pedge[5]));
EdgeDetect edge6 (.clk(clk), .in(in[6]), .out(pedge[6]));
EdgeDetect edge7 (.clk(clk), .in(in[7]), .out(pedge[7]));

endmodule