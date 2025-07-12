module TopModule(
    input  [3:0] x,
    output       f
);

// The truth table encodes f for inputs ordered as {row, col} = {x[2], x[3], x[0], x[1]}
// The bits are arranged so bit 0 corresponds to 0000 with {x[2],x[3],x[0],x[1]} = 0000, bit 15 to 1111.
// This matches the Karnaugh map layout exactly.

localparam [15:0] TRUTH_TABLE = 16'b1011011100000101;

// Reorder bits of x to match Karnaugh map indexing: index = {x[2], x[3], x[0], x[1]}
wire [3:0] index = {x[2], x[3], x[0], x[1]};

assign f = TRUTH_TABLE[index];

endmodule