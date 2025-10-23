module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Directly assign each bit of the input vector to the corresponding output bit
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule