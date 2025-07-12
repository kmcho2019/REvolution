module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector for simplicity and efficiency
assign outv = vec;

// Assign individual bits of the input vector to the output signals for clarity and directness
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule