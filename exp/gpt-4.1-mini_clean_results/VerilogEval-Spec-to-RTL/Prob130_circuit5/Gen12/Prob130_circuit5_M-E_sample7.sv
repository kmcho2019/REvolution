module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);
    // Define a combinational array of 16 4-bit elements
    wire [3:0] lut [0:15];

    // Assign the four mapped indices explicitly
    assign lut[0] = b;
    assign lut[1] = e;
    assign lut[2] = a;
    assign lut[3] = d;

    // For other indices, assign 4'hF
    assign lut[4] = 4'hF;  assign lut[5] = 4'hF;  assign lut[6] = 4'hF;  assign lut[7] = 4'hF;
    assign lut[8] = 4'hF;  assign lut[9] = 4'hF;  assign lut[10] = 4'hF; assign lut[11] = 4'hF;
    assign lut[12] = 4'hF; assign lut[13] = 4'hF; assign lut[14] = 4'hF; assign lut[15] = 4'hF;

    // Output is the selected element of the LUT indexed by c
    assign q = lut[c];

endmodule