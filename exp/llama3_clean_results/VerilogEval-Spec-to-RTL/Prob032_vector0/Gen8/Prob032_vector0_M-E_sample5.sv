module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Define internal signals for the input vector bits
wire sig0, sig1, sig2;

// Assign the input vector bits to internal signals
assign sig0 = vec[0];
assign sig1 = vec[1];
assign sig2 = vec[2];

// Assign the internal signals to the output vector and individual output bits
assign outv = {sig2, sig1, sig0};
assign o2 = sig2;
assign o1 = sig1;
assign o0 = sig0;

endmodule