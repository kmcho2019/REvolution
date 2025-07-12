module TopModule(
    input  wire logic [2:0] vec,
    output wire logic [2:0] outv,
    output wire logic o2,
    output wire logic o1,
    output wire logic o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use bit-wise assignments for the individual output bits
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule