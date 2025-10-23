module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit using a tree-like structure for XOR operations
reg [7:0] in_bits;
always @(*) begin
    in_bits = in;
    parity = (in_bits[0] ^ in_bits[1]) ^ (in_bits[2] ^ in_bits[3]) ^ (in_bits[4] ^ in_bits[5]) ^ (in_bits[6] ^ in_bits[7]);
end

endmodule