module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Create priority mask where all bits right of first '1' are set to '1'
wire [3:0] priority_mask = in | {in[2:0], 1'b0} | {in[1:0], 2'b0} | {in[0], 3'b0};

// Population count of the mask gives us the position (minus 1)
assign pos = priority_mask[0] + priority_mask[1] + priority_mask[2] + priority_mask[3] - 1;

// Handle all-zero case by ANDing with input MSB
assign pos = pos & {2{in != 4'b0000}};

endmodule