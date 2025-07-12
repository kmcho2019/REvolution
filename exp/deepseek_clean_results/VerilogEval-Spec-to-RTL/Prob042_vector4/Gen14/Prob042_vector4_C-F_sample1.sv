module TopModule (
    input  [7:0] in,    // 8-bit signed input
    output [31:0] out   // 32-bit sign-extended output
);
    // Sign-extend by replicating MSB 24 times and concatenating original 8 bits
    assign out = {{24{in[7]}}, in};
endmodule