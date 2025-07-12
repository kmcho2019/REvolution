module TopModule (
    input  [7:0] in,
    output signed [31:0] out
);

    // Explicitly cast input to signed 8-bit, then replicate the sign bit 24 times for upper bits,
    // concatenated with the 8-bit input, resulting in a 32-bit signed output.
    assign out = { {24{ $signed(in)[7] }}, in };

endmodule