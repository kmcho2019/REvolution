module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use wires for intermediate assignments (minor optimization)
wire [2:0] vec_wire;
assign vec_wire = vec;

// Use bit-wise assignments for the individual output bits
assign o2 = vec_wire[2];
assign o1 = vec_wire[1];
assign o0 = vec_wire[0];

endmodule