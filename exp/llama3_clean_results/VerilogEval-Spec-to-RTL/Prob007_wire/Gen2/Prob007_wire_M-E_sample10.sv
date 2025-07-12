module TopModule(
    input  in,  // Input signal
    output out   // Output signal, buffered from input
);

// Instantiate a buffer to mimic a wire's behavior with potential for signal conditioning
buf1 u_buf (
    .A(in),  // Input to the buffer
    .Y(out)  // Output from the buffer
);

endmodule

// Definition of the buffer module used above
module buf1(
    input A,  // Input to the buffer
    output Y  // Output from the buffer
);

// Buffer implementation: a simple assignment
assign Y = A;

endmodule