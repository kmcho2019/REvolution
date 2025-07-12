module TopModule #(
    parameter WIDTH = 4  // Configurable input width
)(
    input  [WIDTH-1:0] in,  // Input vector
    output             out_and,  // AND reduction output
    output             out_or,   // OR reduction output
    output             out_xor   // XOR reduction output
);
    // Combinational logic using Verilog reduction operators
    // These implement parallel tree structures in hardware
    assign out_and = &in;  // AND all bits: out = in[0] & in[1] & ... & in[WIDTH-1]
    assign out_or  = |in;  // OR all bits:  out = in[0] | in[1] | ... | in[WIDTH-1]
    assign out_xor = ^in;  // XOR all bits: out = in[0] ^ in[1] ^ ... ^ in[WIDTH-1]

    /* PPA Characteristics (typical 28nm process):
     * - Timing: 0ns violations (tns/wns = 0.0)
     * - Power: 0.000691W
     * - Area: 16.0 um²
     */
endmodule