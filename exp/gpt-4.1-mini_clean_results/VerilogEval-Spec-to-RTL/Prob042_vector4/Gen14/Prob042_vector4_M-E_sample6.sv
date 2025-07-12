module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Extend input to signed 32-bit by left-shifting 24 bits, then arithmetic right-shifting 24 bits
    // This replicates the sign bit automatically in the upper 24 bits.
    assign out = $signed({in, 24'b0}) >>> 24;

endmodule