module TopModule(
    input  [3:0] x,
    output       f
);

// Define the truth table as a 16-bit constant
// bit position corresponds to the input value x
// 1 for minterms where f=1, 0 otherwise
wire [15:0] truth_table = 16'b1011011100000101;

assign f = truth_table[x];

endmodule