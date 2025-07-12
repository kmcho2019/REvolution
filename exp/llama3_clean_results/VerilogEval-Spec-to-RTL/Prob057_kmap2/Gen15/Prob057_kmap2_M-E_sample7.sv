module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

reg [0:0] lut [0:15];

initial
begin
    // Initialize the lookup table according to the Karnaugh map
    lut[0]  = 1'b1; // 0000
    lut[1]  = 1'b1; // 0001
    lut[2]  = 1'b0; // 0010
    lut[3]  = 1'b1; // 0011
    lut[4]  = 1'b1; // 0100
    lut[5]  = 1'b0; // 0101
    lut[6]  = 1'b0; // 0110
    lut[7]  = 1'b1; // 0111
    lut[8]  = 1'b0; // 1000
    lut[9]  = 1'b1; // 1001
    lut[10] = 1'b1; // 1010
    lut[11] = 1'b1; // 1011
    lut[12] = 1'b1; // 1100
    lut[13] = 1'b1; // 1101
    lut[14] = 1'b0; // 1110
    lut[15] = 1'b0; // 1111
end

always @(*)
begin
    // Use the input combination as an index to select the output from the lookup table
    out = lut[{a, b, c, d}];
end

endmodule