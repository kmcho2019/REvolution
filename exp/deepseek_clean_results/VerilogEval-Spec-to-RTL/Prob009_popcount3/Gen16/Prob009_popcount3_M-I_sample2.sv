module TopModule (
    input [2:0] in,
    output [1:0] out
);

    assign out[1] = &in[1:0] | &in[2:1] | &in[2:0];  // Count >= 2
    assign out[0] = in[0] ^ in[1] ^ in[2];          // Odd count

endmodule