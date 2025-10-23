// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use an always block with a for-loop to reverse the input bits
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out[7 - i] = in[i]; // Assign each input bit to its reversed position in the output
        end
    end

endmodule