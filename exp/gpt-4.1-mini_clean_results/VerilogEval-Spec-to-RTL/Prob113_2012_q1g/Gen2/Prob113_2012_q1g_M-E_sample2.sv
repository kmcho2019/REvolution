module TopModule(
    input  [3:0] x,
    output f
);

// Rows are indexed by x[2]x[3], columns by x[0]x[1]
// To map to ROM index, compute address as {row, col} = {x[2], x[3], x[0], x[1]} is incorrect
// Instead, address = {x[2], x[3], x[0], x[1]} but bits must be correctly ordered.
// The Karnaugh map rows: x[2] (MSB), x[3] (LSB) -> so row = {x[2], x[3]}
// Columns: x[0] (MSB), x[1] (LSB) -> col = {x[0], x[1]}
// Final address = {row, col} = {x[2], x[3], x[0], x[1]}

wire [1:0] row = {x[2], x[3]};
wire [1:0] col = {x[0], x[1]};
wire [3:0] addr = {row, col};

// Define the K-map values as a 16-bit constant, with bit positions corresponding to addr:
// The K-map entries from the problem:
// row\col 00 01 11 10
// 00     1  0  0  1
// 01     0  0  0  0
// 11     1  1  1  0
// 10     1  1  0  1
//
// Each cell corresponds to addr:
// row=00(0), col=00(0) => addr=0: 1
// row=00, col=01(1) => addr=1: 0
// row=00, col=11(3) => addr=3: 0
// row=00, col=10(2) => addr=2: 1
// row=01(1), col=00(0) => addr=4: 0
// row=01, col=01(1) => addr=5: 0
// row=01, col=11(3) => addr=7: 0
// row=01, col=10(2) => addr=6: 0
// row=11(3), col=00(0) => addr=12:1
// row=11, col=01(1) => addr=13:1
// row=11, col=11(3) => addr=15:1
// row=11, col=10(2) => addr=14:0
// row=10(2), col=00(0) => addr=8: 1
// row=10, col=01(1) => addr=9: 1
// row=10, col=11(3) => addr=11:0
// row=10, col=10(2) => addr=10:1

localparam [15:0] kmap = 16'b1110100111010001;

// Indexing from LSB to MSB:
// bit0  = addr=0, bit15=addr=15

assign f = kmap[addr];

endmodule