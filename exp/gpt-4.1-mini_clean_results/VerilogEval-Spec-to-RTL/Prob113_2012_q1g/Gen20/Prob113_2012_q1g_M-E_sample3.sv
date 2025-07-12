module TopModule(
    input  [3:0] x,
    output       f
);

// ROM encoding of function f based on the Karnaugh map
// Bit position = input x (x3x2x1x0), LSB = address 0
// Values: 1,0,1,0,0,0,0,0,1,1,0,1,1,1,0,0
localparam [15:0] ROM = 16'b0011101100101001;

assign f = ROM[x];

endmodule