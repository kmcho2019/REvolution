module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Create a wire to hold the replicated sign bit
    wire [23:0] sign_bit_replicated;

    // Replicate the sign bit 24 times
    assign sign_bit_replicated = {24{in[7]}};

    // Concatenate the replicated sign bit with the original 8-bit number
    assign out = {sign_bit_replicated, in};

endmodule