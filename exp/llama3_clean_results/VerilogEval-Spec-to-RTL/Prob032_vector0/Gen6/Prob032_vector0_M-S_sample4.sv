module TopModule(
    input  [2:0] vec,
    output o2,
    output o1,
    output o0
);

// Directly assign the individual bits of the input vector to the output bits
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule