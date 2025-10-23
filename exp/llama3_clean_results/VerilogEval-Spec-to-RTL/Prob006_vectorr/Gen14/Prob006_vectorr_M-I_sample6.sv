// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);
    // Use a for-loop to assign the input bits to the output in reverse order
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out[i] = in[7 - i];
        end
    end
endmodule