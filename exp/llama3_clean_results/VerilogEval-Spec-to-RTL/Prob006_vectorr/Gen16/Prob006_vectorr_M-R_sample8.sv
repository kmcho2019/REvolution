// Refactored module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    always @(*) begin
        // Iterate over each bit of the input and output vectors
        for (int i = 0; i < 8; i++) begin
            // Assign the i-th bit from the end of the input vector to the i-th bit of the output vector
            out[i] = in[7 - i];
        end
    end

endmodule