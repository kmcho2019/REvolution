module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign individual bits from the input vector to the output vector and individual outputs
assign outv = vec;
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

// Alternatively, we could also directly assign individual bits without using the output vector
// assign outv[2:0] = vec[2:0];
// assign o2 = vec[2];
// assign o1 = vec[1];
// assign o0 = vec[0];

endmodule