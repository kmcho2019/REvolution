module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Use a for loop to assign the bytes of the input vector to the output vector in reverse order
    // This could potentially allow the synthesis tool to find a more efficient implementation
    assign out = {
        in[ 7: 0], // Byte 0
        in[15: 8], // Byte 1
        in[23:16], // Byte 2
        in[31:24]  // Byte 3
    };

    // Alternatively, you could use a generate block to achieve the same result
    // This might provide additional opportunities for the synthesis tool to optimize the design
    // generate
    //     for (genvar i = 0; i < 4; i++) begin
    //         assign out[i*8 +: 8] = in[(3-i)*8 +: 8];
    //     end
    // endgenerate

endmodule