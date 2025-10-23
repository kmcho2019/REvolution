module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Define an intermediate signal for the XNOR operation
wire xnor_out;
assign xnor_out = (in1 == in2); // Directly use equality for XNOR

// Compute the final output 'out' using the intermediate signal
assign out = xnor_out ^ in3;

endmodule