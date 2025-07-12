module TopModule (
    input  [7:0] in,    // 8-bit signed input value
    output [31:0] out   // 32-bit sign-extended output
);
    // Sign-extension using continuous assignment
    assign out = {{24{in[7]}}, in};
endmodule