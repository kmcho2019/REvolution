module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Directly calculate the population count of the 255-bit input vector
assign out = $countones(in);

endmodule