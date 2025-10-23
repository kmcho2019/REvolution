module TopModule(
    input  [255:0] in, // 256 bits
    input  [7:0] sel,  // 8 bits
    output out
);

    assign out = in[sel];

endmodule