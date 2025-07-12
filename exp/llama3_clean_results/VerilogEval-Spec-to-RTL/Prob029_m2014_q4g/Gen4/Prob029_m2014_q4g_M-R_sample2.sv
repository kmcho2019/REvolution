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

// Assign the output 'out' based on the intermediate wire and 'in3'
assign out = xnor_out ^ in3;

endmodule