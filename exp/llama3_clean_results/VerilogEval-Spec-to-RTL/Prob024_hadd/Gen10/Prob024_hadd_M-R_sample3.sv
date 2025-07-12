module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Define intermediate wires for clarity, though not strictly necessary for such a simple circuit
wire sum_wire;
wire cout_wire;

// Using XOR for sum and AND for carry-out
assign sum_wire = a ^ b;  
assign cout_wire = a & b;  

// Assign the results to the output ports
assign sum = sum_wire;
assign cout = cout_wire;

endmodule