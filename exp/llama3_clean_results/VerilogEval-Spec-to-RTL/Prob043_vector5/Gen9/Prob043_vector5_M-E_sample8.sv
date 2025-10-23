module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Create a 5x5 matrix to store the comparison results
wire [4:0] row0 [4:0];
wire [4:0] row1 [4:0];
wire [4:0] row2 [4:0];
wire [4:0] row3 [4:0];
wire [4:0] row4 [4:0];

// Perform bitwise XOR operations between the signals and invert the results
assign row0[0] = ~(a ^ a);
assign row0[1] = ~(a ^ b);
assign row0[2] = ~(a ^ c);
assign row0[3] = ~(a ^ d);
assign row0[4] = ~(a ^ e);

assign row1[0] = ~(b ^ a);
assign row1[1] = ~(b ^ b);
assign row1[2] = ~(b ^ c);
assign row1[3] = ~(b ^ d);
assign row1[4] = ~(b ^ e);

assign row2[0] = ~(c ^ a);
assign row2[1] = ~(c ^ b);
assign row2[2] = ~(c ^ c);
assign row2[3] = ~(c ^ d);
assign row2[4] = ~(c ^ e);

assign row3[0] = ~(d ^ a);
assign row3[1] = ~(d ^ b);
assign row3[2] = ~(d ^ c);
assign row3[3] = ~(d ^ d);
assign row3[4] = ~(d ^ e);

assign row4[0] = ~(e ^ a);
assign row4[1] = ~(e ^ b);
assign row4[2] = ~(e ^ c);
assign row4[3] = ~(e ^ d);
assign row4[4] = ~(e ^ e);

// Flatten the matrix into a 1D array
assign out[24] = row0[0];
assign out[23] = row0[1];
assign out[22] = row0[2];
assign out[21] = row0[3];
assign out[20] = row0[4];

assign out[19] = row1[0];
assign out[18] = row1[1];
assign out[17] = row1[2];
assign out[16] = row1[3];
assign out[15] = row1[4];

assign out[14] = row2[0];
assign out[13] = row2[1];
assign out[12] = row2[2];
assign out[11] = row2[3];
assign out[10] = row2[4];

assign out[9] = row3[0];
assign out[8] = row3[1];
assign out[7] = row3[2];
assign out[6] = row3[3];
assign out[5] = row3[4];

assign out[4] = row4[0];
assign out[3] = row4[1];
assign out[2] = row4[2];
assign out[1] = row4[3];
assign out[0] = row4[4];

endmodule