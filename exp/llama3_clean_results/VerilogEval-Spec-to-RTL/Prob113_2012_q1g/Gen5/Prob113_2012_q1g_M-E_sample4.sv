module TopModule(
    input  [3:0] x,
    output       f
);

    // Initialize the LUT with the output values for each input combination
    reg [0:0] lut [0:15];

    initial begin
        // Initialize the LUT based on the Karnaugh map
        lut[0]  = 1'b1;  // x = 0000
        lut[1]  = 1'b0;  // x = 0001
        lut[2]  = 1'b0;  // x = 0010
        lut[3]  = 1'b1;  // x = 0011
        lut[4]  = 1'b0;  // x = 0100
        lut[5]  = 1'b0;  // x = 0101
        lut[6]  = 1'b0;  // x = 0110
        lut[7]  = 1'b0;  // x = 0111
        lut[8]  = 1'b1;  // x = 1000
        lut[9]  = 1'b1;  // x = 1001
        lut[10] = 1'b1;  // x = 1010
        lut[11] = 1'b0;  // x = 1011
        lut[12] = 1'b1;  // x = 1100
        lut[13] = 1'b1;  // x = 1101
        lut[14] = 1'b0;  // x = 1110
        lut[15] = 1'b1;  // x = 1111
    end

    // Use the input x to address the LUT and retrieve the output value for f
    assign f = lut[x];

endmodule