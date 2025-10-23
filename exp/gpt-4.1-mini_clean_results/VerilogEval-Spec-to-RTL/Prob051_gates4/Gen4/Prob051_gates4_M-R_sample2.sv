module TopModule (
    input  [3:0] in,
    output reg       out_and,
    output reg       out_or,
    output reg       out_xor
);

always @(*) begin
    // Compute 4-input AND by bitwise AND of all bits
    out_and = in[0] & in[1] & in[2] & in[3];
    // Compute 4-input OR by bitwise OR of all bits
    out_or  = in[0] | in[1] | in[2] | in[3];
    // Compute 4-input XOR by bitwise XOR of all bits
    out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
end

endmodule