module TopModule (
    input  [7:0] in,    // 8-bit signed input
    output [31:0] out   // 32-bit sign-extended output
);
    assign out = {{24{in[7]}}, in};  // Replicate sign bit 24 times and concatenate with input
endmodule