module TopModule(
    input  [255:0] in,  // 256-bit input vector
    input  [7:0]  sel,  // 8-bit select signal
    output out        // 1-bit output
);

// Use the sel input as the index to select the desired bit from in
assign out = in[sel];

endmodule