module TopModule(
    input  [255:0] in,  // 256-bit input vector
    input  [7:0] sel,  // 8-bit select signal
    output out       // 1-bit output
);
    
    // Directly select the desired bit from the input vector based on the 'sel' signal
    assign out = in[sel];

endmodule