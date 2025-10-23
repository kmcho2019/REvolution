module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use bit-wise assignments for the individual output bits
assign o2 = outv[2];
assign o1 = outv[1];
assign o0 = outv[0];

endmodule