module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

    // Directly replicate the sign bit 24 times and concatenate it with the input
    // This approach is straightforward and allows the synthesis tool to optimize the logic effectively.
    assign out = {24{in[7]}, in};

endmodule