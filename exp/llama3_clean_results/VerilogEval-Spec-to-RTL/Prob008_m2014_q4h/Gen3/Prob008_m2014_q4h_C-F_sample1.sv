// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  in,  // Input port
    output out  // Output port
);

// Assign the value of 'in' to 'out' using a continuous assignment statement.
assign out = in;

endmodule