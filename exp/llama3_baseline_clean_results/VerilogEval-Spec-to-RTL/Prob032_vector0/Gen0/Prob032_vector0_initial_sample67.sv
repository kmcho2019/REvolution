module TopModule(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

assign outv = vec; // Output the input vector as is
assign o2 = vec[2]; // Assign the MSB of vec to o2
assign o1 = vec[1]; // Assign the middle bit of vec to o1
assign o0 = vec[0]; // Assign the LSB of vec to o0

endmodule