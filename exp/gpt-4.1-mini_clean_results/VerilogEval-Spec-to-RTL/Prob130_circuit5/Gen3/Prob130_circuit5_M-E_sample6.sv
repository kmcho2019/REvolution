module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] lut [0:15];

// Initialize LUT with fixed values based on c
assign lut[0]  = b;
assign lut[1]  = e;
assign lut[2]  = a;
assign lut[3]  = d;
assign lut[4]  = 4'hF;
assign lut[5]  = 4'hF;
assign lut[6]  = 4'hF;
assign lut[7]  = 4'hF;
assign lut[8]  = 4'hF;
assign lut[9]  = 4'hF;
assign lut[10] = 4'hF;
assign lut[11] = 4'hF;
assign lut[12] = 4'hF;
assign lut[13] = 4'hF;
assign lut[14] = 4'hF;
assign lut[15] = 4'hF;

assign q = lut[c];

endmodule