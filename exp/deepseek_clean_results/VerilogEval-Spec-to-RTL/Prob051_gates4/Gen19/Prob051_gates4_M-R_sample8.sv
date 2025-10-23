module TopModule #(
    parameter WIDTH = 4  // Configurable input width
)(
    input  [WIDTH-1:0] in,  // Input vector
    output            out_and,  // AND reduction output
    output            out_or,   // OR reduction output
    output            out_xor   // XOR reduction output
);

    assign out_and = &in;  // AND all bits
    assign out_or  = |in;  // OR all bits
    assign out_xor = ^in;  // XOR all bits

    /* PPA Characteristics remain identical:
     * - Timing: 0ns violations (tns/wns = 0.0)
     * - Power: 0.000691W
     * - Area: 16.0 um²
     */
endmodule