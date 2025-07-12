module TopModule(
    input  in,
    output out
);

// Use a buffer to pass the input directly to the output
buf1 u_buf1 (
    .A(in),  // Input of the buffer
    .Y(out)  // Output of the buffer
);

endmodule

// Define the buffer module
module buf1(
    input  A,
    output Y
);

assign Y = A; // The buffer simply assigns its input to its output

endmodule