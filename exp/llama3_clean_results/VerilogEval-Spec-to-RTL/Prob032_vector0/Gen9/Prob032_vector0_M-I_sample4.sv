module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use the output vector for individual bit assignments
assign o2 = outv[2];
assign o1 = outv[1];
assign o0 = outv[0];

endmodule