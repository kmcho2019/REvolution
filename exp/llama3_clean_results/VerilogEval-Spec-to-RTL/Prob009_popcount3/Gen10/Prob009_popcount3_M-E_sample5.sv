module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Define the lookup table for population counts
    reg [1:0] lut [7:0];

    // Initialize the lookup table with pre-computed counts
    initial begin
        lut[0] = 2'd0;  // 000
        lut[1] = 2'd1;  // 001
        lut[2] = 2'd1;  // 010
        lut[3] = 2'd2;  // 011
        lut[4] = 2'd1;  // 100
        lut[5] = 2'd2;  // 101
        lut[6] = 2'd2;  // 110
        lut[7] = 2'd3;  // 111
    end

    // Use the lookup table to drive the output
    assign out = lut[in];

endmodule