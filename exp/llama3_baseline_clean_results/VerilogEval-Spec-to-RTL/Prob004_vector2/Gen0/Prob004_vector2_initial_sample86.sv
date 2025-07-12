module TopModule(
    input  wire [31:0] in,
    output wire [31:0] out
);

assign out[7:0]   = in[7:0];   // Assign the first byte of input to the last byte of output
assign out[15:8] = in[15:8];  // Assign the second byte of input to the second last byte of output
assign out[23:16] = in[23:16]; // Assign the third byte of input to the second byte of output
assign out[31:24] = in[31:24]; // Assign the last byte of input to the first byte of output

endmodule