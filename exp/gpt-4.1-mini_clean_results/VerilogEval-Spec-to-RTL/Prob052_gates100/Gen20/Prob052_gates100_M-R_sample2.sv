module TopModule (
    input  [99:0] in,
    output       out_and,  // Output is 1 only if all 100 input bits are 1 (100-input AND)
    output       out_or,   // Output is 1 if any one or more of the 100 input bits is 1 (100-input OR)
    output       out_xor   // Output is the parity of the 100 input bits (100-input XOR)
);

    // Continuous assignments using Verilog reduction operators
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule