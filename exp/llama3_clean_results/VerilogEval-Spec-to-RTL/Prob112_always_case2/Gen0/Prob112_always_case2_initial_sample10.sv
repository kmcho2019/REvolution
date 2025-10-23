module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit output for position
);

    // Check each bit of the input vector from MSB to LSB
    assign pos[1] = (in[3] || in[2]) ? 1'b1 : 1'b0;
    assign pos[0] = (in[3]) ? 1'b1 : (in[2]) ? 1'b1 : (in[1]) ? 1'b0 : 1'b0;

endmodule