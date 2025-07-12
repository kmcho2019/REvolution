module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use internal signals for the individual output bits
wire sig0, sig1, sig2;
assign sig0 = vec[0];
assign sig1 = vec[1];
assign sig2 = vec[2];

// Assign the internal signals to the individual output bits
assign o2 = sig2;
assign o1 = sig1;
assign o0 = sig0;

endmodule