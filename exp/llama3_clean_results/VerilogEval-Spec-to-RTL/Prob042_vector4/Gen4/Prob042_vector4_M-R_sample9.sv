module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Define a wire to hold the sign bit replicated 24 times
    wire [23:0] sign_bit_extension;

    // Use an assign statement to replicate the sign bit
    assign sign_bit_extension = {24{in[7]}};

    // Assign the output by concatenating the sign bit extension with the input
    assign out = {sign_bit_extension, in};

endmodule