module TopModule #(
    parameter WIDTH = 4  // Configurable input width (default 4 for this problem)
)(
    input  [WIDTH-1:0] in,  // Input vector
    output logic       out_and,  // AND reduction output
    output logic       out_or,   // OR reduction output
    output logic       out_xor   // XOR reduction output
);

    // Optimal implementation using reduction operators
    always_comb begin
        out_and = &in;  // Equivalent to: in[0] & in[1] & in[2] & in[3]
        out_or  = |in;  // Equivalent to: in[0] | in[1] | in[2] | in[3]
        out_xor = ^in;  // Equivalent to: in[0] ^ in[1] ^ in[2] ^ in[3]
    end

    /* Alternative hierarchical implementation (commented out as documentation)
    // First level gates
    wire and01 = in[0] & in[1];
    wire and23 = in[2] & in[3];
    wire or01  = in[0] | in[1];
    wire or23  = in[2] | in[3];
    wire xor01 = in[0] ^ in[1];
    wire xor23 = in[2] ^ in[3];
    
    // Second level gates
    assign out_and = and01 & and23;
    assign out_or  = or01  | or23;
    assign out_xor = xor01 ^ xor23;
    */

    /* Gate-level equivalent documentation:
     * AND: 4-input AND gate or two 2-input ANDs in series
     * OR:  4-input OR gate or two 2-input ORs in series
     * XOR: 3 XOR gates in series (since XOR is not associative like AND/OR)
     */
endmodule