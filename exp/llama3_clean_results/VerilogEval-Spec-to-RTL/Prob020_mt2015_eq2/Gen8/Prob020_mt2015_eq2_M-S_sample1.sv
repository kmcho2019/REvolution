// Module to compare two 2-bit inputs and produce an output based on equality
module TopModule(
    input [1:0] A,  // First 2-bit input
    input [1:0] B,  // Second 2-bit input
    output z         // Output indicating whether A equals B
);

// Assign z to 1 if A equals B, otherwise assign z to 0
assign z = (A == B);

endmodule