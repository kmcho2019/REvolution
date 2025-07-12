module TopModule (
    input  [7:0] in,    // 8-bit signed input to be sign-extended
    output [31:0] out   // 32-bit sign-extended output
);
    /*
    * Sign-extension implementation:
    * 1. Takes the MSB (sign bit) of the 8-bit input
    * 2. Replicates it 24 times (32-8=24) to fill the upper bits
    * 3. Concatenates with the original 8 bits to form 32-bit output
    * This preserves the two's complement value while expanding to 32 bits
    */
    assign out = {{24{in[7]}}, in};
    
    // Note: For parameterized version (future use):
    // parameter IN_WIDTH = 8;
    // localparam EXT_BITS = 32 - IN_WIDTH;
    // assign out = {{EXT_BITS{in[IN_WIDTH-1]}}, in};
endmodule