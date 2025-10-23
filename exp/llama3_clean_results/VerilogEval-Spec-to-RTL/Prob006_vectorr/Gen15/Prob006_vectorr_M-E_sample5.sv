// Novel module to reverse the bit ordering of an 8-bit input using a for-loop
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out  // 8-bit output vector
);

    // Use a for-loop within an always block to reverse the bit ordering
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out[7 - i] = in[i];
        end
    end

endmodule