module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend 8-bit input to 32 bits:
    // replicate the sign bit (MSB) 24 times, then concatenate with original 8-bit input.
    assign out = {{24{in[7]}}, in};

endmodule