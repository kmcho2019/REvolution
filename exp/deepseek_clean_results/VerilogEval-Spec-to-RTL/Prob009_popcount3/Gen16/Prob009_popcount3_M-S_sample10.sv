module TopModule (
    input [2:0] in,
    output [1:0] out
);

    assign out[0] = ^in;          // XOR all bits for LSB of count
    assign out[1] = &in[2:1] |   // All upper bits are 1
                   &in[2:0] |    // All bits are 1
                   (in[2] & in[0]); // Any two bits including MSB and LSB

endmodule