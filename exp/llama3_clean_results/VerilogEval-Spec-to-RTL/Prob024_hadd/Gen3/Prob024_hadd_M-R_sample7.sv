module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Internal wires to hold the sum and carry-out calculations
wire sum_internal;
wire cout_internal;

// Calculate sum using XOR operation (a XOR b)
assign sum_internal = a ^ b;

// Calculate carry-out using AND operation (a AND b)
assign cout_internal = a & b;

// Assign the internal calculations to the output ports
assign sum = sum_internal;
assign cout = cout_internal;

endmodule