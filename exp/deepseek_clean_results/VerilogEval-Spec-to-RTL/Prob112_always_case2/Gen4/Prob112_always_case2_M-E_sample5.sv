module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] mask;
wire [3:0] transitions;

// Create thermometer mask (all bits below first '1' are set)
assign mask[0] = in[0];
assign mask[1] = in[1] | mask[0];
assign mask[2] = in[2] | mask[1];
assign mask[3] = in[3] | mask[2];

// Find transitions (01 patterns) in the mask
assign transitions[0] = ~mask[0];  // Special case for first bit
assign transitions[1] = mask[0] & ~mask[1];
assign transitions[2] = mask[1] & ~mask[2];
assign transitions[3] = mask[2] & ~mask[3];

// Encode the transition position
assign pos[0] = transitions[1] | transitions[3];
assign pos[1] = transitions[2] | transitions[3];

endmodule