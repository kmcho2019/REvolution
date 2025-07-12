// TopModule: A simple combinational module that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  in,  // Input signal
    output out  // Output signal, directly assigned the value of 'in'
);

// Directly assign the value of 'in' to 'out'
assign out = in;

endmodule