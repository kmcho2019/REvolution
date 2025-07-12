module TopModule (
    input  [7:0] in,    // 8-bit signed input
    output [31:0] out   // 32-bit sign-extended output
);

    // Continuous assignment for pure combinational logic
    assign out = {{24{in[7]}}, in};

    /*
    * Efficient sign-extension:
    * - Replicates MSB (sign bit) 24 times
    * - Concatenates with original 8 bits
    * - Zero-delay combinational path
    */
endmodule