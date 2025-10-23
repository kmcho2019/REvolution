module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit by XORing all input bits explicitly
always @(*) begin
    parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];
end

endmodule