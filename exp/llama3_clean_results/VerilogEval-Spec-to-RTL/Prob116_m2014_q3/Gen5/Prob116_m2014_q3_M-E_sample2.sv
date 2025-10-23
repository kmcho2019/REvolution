module TopModule(
    input [3:0] x,
    output reg f
);

// Declare a lookup table (ROM) that maps input combinations to their corresponding outputs
reg [0:0] lut[0:15]; // 2^4 = 16 possible input combinations, each output is 1 bit

// Initialize the lookup table according to the Karnaugh map
initial begin
    lut[0] = 1'b0; // x = 0000
    lut[1] = 1'b0; // x = 0001
    lut[2] = 1'b0; // x = 0010
    lut[3] = 1'b0; // x = 0011
    lut[4] = 1'b0; // x = 0100
    lut[5] = 1'b0; // x = 0101
    lut[6] = 1'b0; // x = 0110
    lut[7] = 1'b1; // x = 0111
    lut[8] = 1'b1; // x = 1000
    lut[9] = 1'b1; // x = 1001
    lut[10] = 1'b0; // x = 1010
    lut[11] = 1'b0; // x = 1011
    lut[12] = 1'b1; // x = 1100
    lut[13] = 1'b1; // x = 1101
    lut[14] = 1'b0; // x = 1110
    lut[15] = 1'b0; // x = 1111
end

// Use the lookup table to generate the output f
always @(*) begin
    f = lut[x];
end

endmodule