module TopModule(
    input  [31:0] in,
    output [31:0] out
);
    // The original code already efficiently reverses the byte order.
    // No significant optimizations can be made without more specific technology or synthesis tool information.
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
endmodule