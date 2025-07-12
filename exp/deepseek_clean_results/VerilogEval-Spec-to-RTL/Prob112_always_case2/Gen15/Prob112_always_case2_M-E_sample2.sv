module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] therm;
wire [3:0] transitions;

// Generate thermometer code (all bits to left of first 1 are set)
assign therm[3] = in[3];
assign therm[2] = in[3] | in[2];
assign therm[1] = therm[2] | in[1];
assign therm[0] = therm[1] | in[0];

// Find transitions between thermometer bits
assign transitions[3:1] = therm[3:1] ^ therm[2:0];
assign transitions[0] = therm[0]; // Special case for LSB

// Encode the transition position
assign pos[1] = transitions[3] | transitions[2];
assign pos[0] = transitions[3] | transitions[1];

endmodule