// Novel Module TopModule: Using a multiplexer for input-output assignment.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Use a multiplexer to conditionally pass the input to the output
    // The select line is tied to the input itself, and the other data input is '0'
    // This configuration ensures that when in is '1', out will be '1', and when in is '0', out will be '0'
    logic constant_zero;
    assign constant_zero = 1'b0;
    assign out = (in) ? in : constant_zero;

endmodule