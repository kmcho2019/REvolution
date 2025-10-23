// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use an always block to reverse the bit ordering of the input
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out[i] = in[7 - i]; // Assign each bit of out to the reversed bit of in
        end
    end

endmodule