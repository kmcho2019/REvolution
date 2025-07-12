module TopModule(
    input  [3:0] in,
    output reg   out_and,
    output reg   out_or,
    output reg   out_xor
);

always @* begin
    // Compute AND by ANDing each bit explicitly
    out_and = in[0] & in[1] & in[2] & in[3];
    
    // Compute OR by ORing each bit explicitly
    out_or  = in[0] | in[1] | in[2] | in[3];
    
    // Compute XOR by XORing each bit explicitly
    out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
end

endmodule