// TopModule: A 2-input AND gate implemented using direct assignment
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out // Output of the AND gate
);

// Directly assign the output based on the input values using conditional operator
assign out = (a == 1'b1 && b == 1'b1) ? 1'b1 : 1'b0;

endmodule