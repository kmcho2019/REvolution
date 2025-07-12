module TopModule (
    input  [7:0] in,       // 8-bit signed input value
    output [31:0] out      // 32-bit sign-extended output
);
    // Efficient sign-extension by replicating the MSB (sign bit) 24 times
    // and concatenating with the original 8-bit input
    assign out = {{24{in[7]}}, in};
endmodule