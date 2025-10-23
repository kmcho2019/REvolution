module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Directly assign each bit output from the input vector
assign o0 = vec[0];
assign o1 = vec[1];
assign o2 = vec[2];

// Concatenate the single-bit outputs to form the 3-bit output vector
assign outv = {o2, o1, o0};

endmodule