// Module to reverse the bit ordering of a 100-bit input vector
module TopModule(
    input  [99:0] in,  // 100-bit input vector
    output [99:0] out  // 100-bit output vector
);

// Directly assign each output bit to the corresponding input bit in reverse order
// This approach is concise and should be efficient for synthesis.
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        out[99 - i] = in[i];  // Reverse the bits
    end
end

endmodule