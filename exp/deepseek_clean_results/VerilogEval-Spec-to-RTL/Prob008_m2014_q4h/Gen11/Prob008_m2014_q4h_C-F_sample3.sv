module TopModule (
    input wire in,    // Explicit wire declaration for input
    output wire out   // Explicit wire declaration for output
);
    assign out = in;  // Direct combinational connection
endmodule