module TopModule (
    input  wire in,    // One-bit input signal
    output wire out    // One-bit output signal: logical NOT of 'in'
);
    // Continuously assign the bitwise negation of input 'in' to output 'out'.
    // This pure combinational logic infers a minimal inverter.
    assign out = ~in;
endmodule