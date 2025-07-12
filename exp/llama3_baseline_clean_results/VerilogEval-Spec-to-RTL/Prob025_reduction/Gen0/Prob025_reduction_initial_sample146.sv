module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // Parity bit output
);

// Using $countones function for even parity
always @(*) begin
    if ($countones(in) % 2 == 1) begin
        parity = 1'b1; // Set parity bit if count of 1's is odd
    end else begin
        parity = 1'b0; // Clear parity bit if count of 1's is even
    end
end

// Alternatively, using XOR operator sequentially
// assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule