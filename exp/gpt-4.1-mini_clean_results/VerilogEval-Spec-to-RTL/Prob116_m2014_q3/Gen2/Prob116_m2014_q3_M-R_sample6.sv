module TopModule (
    input  [3:0] x,
    output      f
);

// Define the function values in a 16-bit vector where index = {x[3], x[0], x[1], x[2]}
localparam [15:0] LUT = 16'b00000010011011011011;

// Let's decode LUT:
// Index (binary) : f (from K-map with d chosen as 0)
// 0000: x3=0,x0=0,x1=0,x2=0 => d -> 0
// 0001: 0
// 0010: d ->0
// 0011: d ->0
// 0100: 0
// 0101: d ->0
// 0110: 1
// 0111: 0
// 1000: 1
// 1001: 1
// 1010: 0
// 1011: 0
// 1100: 1
// 1101: 1
// 1110: 0
// 1111: 0

assign f = LUT[{x[3], x[0], x[1], x[2]}];

endmodule