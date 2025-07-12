module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

// Direct computation of parity using XOR reduction operator
// This is already an efficient implementation, but ensuring the synthesis tool
// optimizes the XOR tree structure is key for best PPA metrics.
assign parity = ^in;

endmodule