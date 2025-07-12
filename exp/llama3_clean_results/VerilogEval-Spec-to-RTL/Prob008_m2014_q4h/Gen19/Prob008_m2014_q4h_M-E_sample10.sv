// Novel Solution: Utilizing a Multiplexer for Input Bypass
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Using the input as the select line for the MUX
    // Since the output must be the same as the input, the input itself acts as the control
    assign out = (in) ? in : in;
endmodule