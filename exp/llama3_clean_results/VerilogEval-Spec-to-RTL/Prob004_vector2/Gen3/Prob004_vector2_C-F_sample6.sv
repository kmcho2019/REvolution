module TopModule(
    input [31:0] in,
    output [31:0] out
);

// Directly assign the bytes in reverse order to the output.
// This approach is straightforward and easy to understand, making it maintainable and scalable.
assign out[31:24] = in[7:0];  // Assign the least significant byte of 'in' to the most significant byte of 'out'.
assign out[23:16] = in[15:8]; // Assign the second byte of 'in' to the second most significant byte of 'out'.
assign out[15:8]  = in[23:16]; // Assign the third byte of 'in' to the third most significant byte of 'out'.
assign out[7:0]   = in[31:24]; // Assign the most significant byte of 'in' to the least significant byte of 'out'.

endmodule