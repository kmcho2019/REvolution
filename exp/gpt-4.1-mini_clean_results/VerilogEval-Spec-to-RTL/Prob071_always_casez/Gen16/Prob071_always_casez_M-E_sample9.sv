module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

wire [7:0] masked;

// Generate mask: zero bits above the first set bit (lowest priority)
assign masked = in & (~in + 1); // isolate lowest set bit (one-hot)

wire b0, b1, b2;

// Binary encode the one-hot masked bit
// Position bits are determined by checking which bit in masked is set
assign b0 = masked[1] | masked[3] | masked[5] | masked[7];
assign b1 = masked[2] | masked[3] | masked[6] | masked[7];
assign b2 = masked[4] | masked[5] | masked[6] | masked[7];

assign pos = (masked == 8'b0) ? 3'd0 : {b2, b1, b0};

endmodule