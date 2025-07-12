// Module TopModule: Buffer-based implementation
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Directly assign the input to the output using a buffer
buf1 u_buf1 (.A(in), .Y(out));

endmodule

// Define the buffer module
module buf1(
    input  logic A,
    output logic Y
);
assign Y = A;
endmodule