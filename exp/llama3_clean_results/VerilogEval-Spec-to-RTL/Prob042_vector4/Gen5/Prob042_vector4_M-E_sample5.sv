module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Determine the sign extension part based on the sign bit of the input
    // If the sign bit is 1, the first 24 bits should be all 1s; otherwise, all 0s
    assign out = (in[7] ? 24'hFFFFFFFF : 24'h00000000) | (in << 24);

endmodule