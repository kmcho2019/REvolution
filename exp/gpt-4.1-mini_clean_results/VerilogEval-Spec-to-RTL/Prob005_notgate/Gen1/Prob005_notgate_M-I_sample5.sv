module TopModule (
    input  wire in,
    output wire out
);
    // Structural inverter instantiation for explicit inversion
    assign out = ~in;
endmodule