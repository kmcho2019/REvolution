module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Optimal sign-extension from 8-bit to 32-bit
    // Replicates the sign bit (in[7]) 24 times and concatenates with original 8 bits
    assign out = {{24{in[7]}}, in};
endmodule