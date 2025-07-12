module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Single-stage sign extension: replicate sign bit 24 times followed by 8-bit input
    assign out = { {24{in[7]}}, in };

endmodule