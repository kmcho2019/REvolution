module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Sign-extend 8-bit input to 32 bits by replicating the sign bit 24 times
    // The sign bit (in[7]) is replicated 24 times and concatenated with 'in'
    assign out = { {24{in[7]}}, in };

endmodule