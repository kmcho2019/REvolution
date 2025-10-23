// Define a submodule to split the input vector into individual bits
module VectorSplitter(
    input  [2:0] vec,
    output o2,
    output o1,
    output o0
);

assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule

// Define the TopModule with the new structural approach
module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Instantiate the VectorSplitter submodule
VectorSplitter vs(
    .vec(vec),
    .o2(o2),
    .o1(o1),
    .o0(o0)
);

endmodule