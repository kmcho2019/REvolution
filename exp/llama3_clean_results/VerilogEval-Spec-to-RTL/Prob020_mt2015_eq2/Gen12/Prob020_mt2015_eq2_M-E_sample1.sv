module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

logic [1:0] diff;

assign diff = A ^ B; // Bitwise XOR to find differing bits
assign z = ~(diff[1] | diff[0]); // Reduction OR and inversion to check if all bits are 0

endmodule