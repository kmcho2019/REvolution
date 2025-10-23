module TopModule #(
    parameter WIDTH = 4  // Configurable width for potential reuse
)(
    input  [WIDTH-1:0] in,  // Input vector
    output             out_and,  // AND reduction output
    output             out_or,   // OR reduction output
    output             out_xor   // XOR reduction output
);

    // Combinational logic using Verilog reduction operators
    assign out_and = &in;  // AND reduction: out_and = in[0] & in[1] & ... & in[WIDTH-1]
    assign out_or  = |in;  // OR reduction:  out_or  = in[0] | in[1] | ... | in[WIDTH-1]
    assign out_xor = ^in;  // XOR reduction: out_xor = in[0] ^ in[1] ^ ... ^ in[WIDTH-1]

    /* PPA Characteristics (expected):
       - Timing: 0ns violations (combinational path)
       - Power: Minimal (only gate switching power)
       - Area: Efficient (direct mapping to standard cells)
    */
endmodule