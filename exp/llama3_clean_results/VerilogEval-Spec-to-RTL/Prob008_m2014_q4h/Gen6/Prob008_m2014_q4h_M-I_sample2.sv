// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Assign the value of 'in' to 'out' using a continuous assignment statement.
// This is the most efficient way to implement this functionality in Verilog.
assign out = in;

endmodule