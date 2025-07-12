// Module to count the number of '1's in a 3-bit input vector using a LUT
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the count
);

    // Define the LUT for population counts
    // Each entry in the LUT corresponds to a possible input combination
    // The value at each entry is the count of '1's for that input combination
    reg [1:0] lut [7:0];
    initial begin
        // Initialize the LUT with population counts for each input combination
        lut[0] = 2'd0;  // 000
        lut[1] = 2'd1;  // 001
        lut[2] = 2'd1;  // 010
        lut[3] = 2'd2;  // 011
        lut[4] = 2'd1;  // 100
        lut[5] = 2'd2;  // 101
        lut[6] = 2'd2;  // 110
        lut[7] = 2'd3;  // 111
    end

    // Use the input vector as an index to the LUT to get the population count
    assign out = lut[in];

endmodule