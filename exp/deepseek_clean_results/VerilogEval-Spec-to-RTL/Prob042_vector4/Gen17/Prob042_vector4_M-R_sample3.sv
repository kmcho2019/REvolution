module TopModule (
    input  [7:0] in,    // 8-bit signed input to be sign-extended
    output reg [31:0] out   // 32-bit sign-extended output (now as reg)
);

    // Procedural implementation of sign-extension
    always @(*) begin
        out = {{24{in[7]}}, in};
    end

    /*
    * Same sign-extension logic as before:
    * - Replicates MSB (sign bit) 24 times
    * - Concatenates with original 8 bits
    * - Preserves two's complement value
    */
endmodule