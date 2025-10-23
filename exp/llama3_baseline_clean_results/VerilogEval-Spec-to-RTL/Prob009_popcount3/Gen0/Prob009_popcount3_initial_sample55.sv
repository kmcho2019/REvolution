module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector
);

// Internal wire to hold the count
wire [1:0] count;

// Bitwise OR operations and additions to count the number of '1's
assign count[0] = in[0] ^ in[1] ^ in[2];
assign count[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

// Output the count
assign out = count;

endmodule