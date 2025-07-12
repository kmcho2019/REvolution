module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Half Adder Implementation:
// sum = a XOR b
// cout = a AND b
// Minimal combinational logic with no intermediate signals.

assign sum = a ^ b;
assign cout = a & b;

endmodule