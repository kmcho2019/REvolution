module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Define the LUTs for each combination of 'a' and 'b'
wire [3:0] lut_ab_00, lut_ab_01, lut_ab_11, lut_ab_10;

// Initialize the LUTs based on the Karnaugh map
assign lut_ab_00 = 4'b1101;  // For ab = 00
assign lut_ab_01 = 4'b1001;  // For ab = 01
assign lut_ab_11 = 4'b0111;  // For ab = 11
assign lut_ab_10 = 4'b1000;  // For ab = 10

// Select the appropriate LUT based on 'a' and 'b'
wire [3:0] selected_lut;
assign selected_lut = (~a & ~b)? lut_ab_00 :
                      (~a & b) ? lut_ab_01 :
                      (a & b)  ? lut_ab_11 :
                      (a & ~b) ? lut_ab_10 : 4'b0000;

// Determine the output 'out' based on the selected LUT and 'c' and 'd'
assign out = (c == 0 && d == 0)? selected_lut[0] :
             (c == 0 && d == 1)? selected_lut[1] :
             (c == 1 && d == 1)? selected_lut[2] :
             (c == 1 && d == 0)? selected_lut[3] : 1'b0;

endmodule