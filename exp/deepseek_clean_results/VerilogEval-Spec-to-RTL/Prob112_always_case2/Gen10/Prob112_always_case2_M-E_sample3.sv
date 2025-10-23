module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Create thermometer code by OR-ing higher bits
wire [3:0] therm;
assign therm[3] = in[3];
assign therm[2] = in[3] | in[2];
assign therm[1] = therm[2] | in[1];
assign therm[0] = therm[1] | in[0];

// Thermometer to binary encoder
assign pos[1] = therm[3] | therm[2];
assign pos[0] = therm[3] | (~therm[2] & therm[1]);

endmodule