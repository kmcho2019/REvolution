module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Reverse byte order of 32-bit input vector:
    // Output bytes: {input byte0, input byte1, input byte2, input byte3}
    // where input byte0 = in[7:0] (LSB) and input byte3 = in[31:24] (MSB)
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
endmodule