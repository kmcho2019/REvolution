module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate wire to represent the output of the XNOR operation
wire xnor_out;

// Assign the output of the XNOR operation to the intermediate wire
assign xnor_out = ~(in1 ^ in2);

// Directly combine the XNOR and XOR operations in a single statement for 'out'
assign out = xnor_out ^ in3;

endmodule