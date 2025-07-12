module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire [23:0] sign_ext_bits;

    // Replicate the sign bit (in[7]) 24 times
    assign sign_ext_bits = {24{in[7]}};

    // Concatenate replicated bits with original input to form 32-bit signed extended output
    assign out = {sign_ext_bits, in};

endmodule