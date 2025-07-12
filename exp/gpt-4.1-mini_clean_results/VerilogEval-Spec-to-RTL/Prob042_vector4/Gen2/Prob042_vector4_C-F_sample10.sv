module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend 8-bit input to 32 bits by replicating the sign bit (MSB) 24 times
    // followed by the original 8 bits, preserving the signed value.
    assign out = {{24{in[7]}}, in};
endmodule