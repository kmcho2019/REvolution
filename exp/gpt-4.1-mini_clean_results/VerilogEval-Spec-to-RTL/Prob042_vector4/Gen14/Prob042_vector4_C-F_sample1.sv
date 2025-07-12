// TopModule: Sign-extends an 8-bit input to 32 bits by replicating the sign bit (MSB) 24 times.
module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Sign-extend by replicating the MSB (bit 7) 24 times, then concatenate with the input.
    assign out = {{24{in[7]}}, in};

endmodule