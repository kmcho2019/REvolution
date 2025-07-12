module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Internal signal to hold the output of the XNOR operation
wire xnor_out;

// Implement the XNOR operation
assign xnor_out = (in1 == in2);

// Implement the XOR operation using the XNOR output and 'in3'
assign out = xnor_out ^ in3;

endmodule