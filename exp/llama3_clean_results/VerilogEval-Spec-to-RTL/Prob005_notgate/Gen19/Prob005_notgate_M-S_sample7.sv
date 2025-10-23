// TopModule: A simple Verilog module implementing a NOT gate.
module TopModule(
    input  logic in,
    output logic out
);

    assign out = ~in;  // Invert the input signal

endmodule