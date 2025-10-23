module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Step 1: Create thermometer code (all bits left of first '1' become '1')
wire [3:0] therm;
assign therm[3] = in[3];
assign therm[2] = in[3] | in[2];
assign therm[1] = therm[2] | in[1];
assign therm[0] = therm[1] | in[0];

// Step 2: XOR adjacent bits to find transition point
wire [2:0] transitions;
assign transitions[2] = therm[3] ^ therm[2];
assign transitions[1] = therm[2] ^ therm[1];
assign transitions[0] = therm[1] ^ therm[0];

// Step 3: Logarithmic encoding of transition position
assign pos[1] = transitions[2] | transitions[1];
assign pos[0] = transitions[2] | (transitions[0] & ~transitions[1]);

endmodule